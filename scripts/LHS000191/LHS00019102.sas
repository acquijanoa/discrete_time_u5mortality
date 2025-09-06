

%macro missing_report(data=, outpath=, outname=,subtitle=);

    /* Step 1: Get variable names and labels, excluding labels with 'NA' */
    proc contents data=&data out=varinfo(keep=name label type) noprint;
    run;

    data varinfo_filtered;
        set varinfo;
        if index(upcase(label), 'NA -') = 0; /* Exclude labels containing 'NA' */
    run;

    /* Separate numeric and character variable names */
    proc sql noprint;
        select name into :num_vars separated by ' '
        from varinfo_filtered where type = 1;
        %let num_count = &sqlobs;

        select name into :char_vars separated by ' '
        from varinfo_filtered where type = 2;
        %let char_count = &sqlobs;
    quit;

    /* Step 2: Calculate missing % for each variable */
    data missing_report;
        set &data end=last;

        array num_vars {*} &num_vars;
        array char_vars {*} $ &char_vars;

        array num_miss[&num_count] _temporary_;
        array char_miss[&char_count] _temporary_;

        retain total 0;

        /* Initialize counters only on first iteration */
        if _N_ = 1 then do;
            do i = 1 to &num_count; num_miss[i] = 0; end;
            do i = 1 to &char_count; char_miss[i] = 0; end;
        end;

        total + 1;

        do i = 1 to dim(num_vars);
            if missing(num_vars[i]) then num_miss[i] + 1;
        end;

        do i = 1 to dim(char_vars);
            if missing(char_vars[i]) then char_miss[i] + 1;
        end;

        if last then do;
            do i = 1 to &num_count;
                varname = scan("&num_vars", i);
                miss_pct = (num_miss[i] / total) * 100;
                if miss_pct = . then miss_pct = 0;
                output;
            end;
            do i = 1 to &char_count;
                varname = scan("&char_vars", i);
                miss_pct = (char_miss[i] / total) * 100;
                if miss_pct = . then miss_pct = 0;
                output;
            end;
        end;

        keep varname miss_pct;
    run;

    /* Step 3: Merge with labels */
    proc sql;
        create table final_report_unsorted as
        select a.varname, b.label, a.miss_pct
        from missing_report a
        left join varinfo_filtered b
        on upcase(a.varname) = upcase(b.name);
    quit;

    /* Step 4: Sort by percent missing ascending */
    proc sort data=final_report_unsorted out=final_report;
        by varname;
    run;

    /* Step 5: Export to RTF */
    ods rtf file="&outpath./&outname..rtf" style=journal;

    proc print data=final_report noobs label;
        title "Missing Data Report (Sorted by Percent Missing)";
		title2 "&subtitle.";
        var varname label miss_pct;
        label
            varname = "Variable Name"
            label = "Variable Label"
            miss_pct = "Percent Missing";
        format miss_pct 6.2;
    run;

    ods rtf close;

%mend;

