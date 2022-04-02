fun is_older(first_date:int*int*int, second_date:int*int*int) = 
    if ((#1 first_date) = (#1 second_date)) andalso ((#2 first_date) = (#2 second_date)) andalso ((#3 first_date) = (#3 second_date))
        then false
    else if (#1 first_date) < (#1 second_date)
        then true
    else if (#1 first_date) = (#1 second_date) andalso (#2 first_date) < (#2 second_date)
        then true
    else if (#1 first_date) = (#1 second_date) andalso (#2 first_date) = (#2 second_date) andalso (#3 first_date) < (#3 second_date)
        then true
    else false;

is_older((1995,2,3),(1995,2,3)); (*false*)
is_older((1999,1,15),(1999,1,16)); (*true*)
is_older((1999,1,15),(1999,2,15)); (*true*)
is_older((1999,1,15),(2000,1,15)); (*true*)
is_older((1999,1,15),(1998,1,15)); (*false*)
is_older((1999,1,15),(1999,1,14)); (*false*)
is_older((1999,1,15),(1999,0,15)); (*false*)

fun number_in_month(list_of_dates : (int*int*int) list, month : int) =
    if null list_of_dates
        then 0
    else if ((#2 (hd list_of_dates)) = month)
        then 1 + number_in_month(tl list_of_dates,month)
    else number_in_month(tl list_of_dates,month);

number_in_month([],4); (*0*)
number_in_month([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],4); (*3*)
number_in_month([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],3); (*1*)
number_in_month([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],7); (*0*)
number_in_month([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],5); (*1*)

fun number_in_months(list_of_dates : (int*int*int) list, monthes : int list) = 
    if null monthes
        then 0
    else number_in_month(list_of_dates, (hd monthes)) + number_in_months(list_of_dates, (tl monthes));

number_in_months([],[4,3]); (*0*)
number_in_months([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],[]); (*0*)
number_in_months([],[]); (*0*)
number_in_months([(1995,2,3), (1995,3,3), (1995,4,3), (1995,4,3), (1995,5,3), (1995,4,3)],[4,3]); (*4*)

fun dates_in_month(list_of_dates : (int*int*int) list, month : int) = 
    if null list_of_dates
        then []
    else if ((#2 (hd list_of_dates)) = month)
        then (hd list_of_dates) :: dates_in_month(tl list_of_dates,month)
    else dates_in_month(tl list_of_dates,month);

dates_in_month([],4);
dates_in_month([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],4);
dates_in_month([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],5);
dates_in_month([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],10);

fun dates_in_months (list_of_dates : (int*int*int) list, monthes : int list) = 
    if null monthes
        then []
    else dates_in_month(list_of_dates, (hd monthes)) @ dates_in_months(list_of_dates, (tl monthes));

dates_in_months([],[4,5]);
dates_in_months([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],[]);
dates_in_months([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],[4,5]);
dates_in_months([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1995,4,3)],[4,5,10]);

fun get_nth (stings_list : string list, n:int) = 
    if null stings_list
    then ""
    else if n = 1
        then (hd stings_list)
    else get_nth(tl stings_list, n-1);

get_nth([],4);
get_nth(["1","2","3","4","5"],4);

fun date_to_string(date : int*int*int) = 
    let val monthes : string list = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
    get_nth(monthes,(#2 date)) ^ " " ^Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end;

date_to_string((2003,7,25));

fun number_before_reaching_sum (sum : int, list_of_nums : int list) = 
    if null list_of_nums
    then 0
    else if (sum-(hd list_of_nums)<=0)
    then 0
    else 1+number_before_reaching_sum(sum - (hd list_of_nums), (tl list_of_nums));

number_before_reaching_sum(4,[1,2,3,4]);
number_before_reaching_sum(4,[]);

fun what_month (day : int) = 
    let 
        val monthes = [31,28,31,30,31,30,31,31,30,31,30,31]
    in
        number_before_reaching_sum(day, monthes)+1
    end;

what_month(32);

fun month_range(day1 : int, day2 : int) =
    if (day1>day2) 
    then [] 
    else what_month(day1) :: month_range(day1+1, day2);

month_range(30,33);

fun oldest(dates : (int*int*int) list) = 
    if null dates
        then "NONE"
    else 
    let 
        fun greatest(dates : (int*int*int) list) = 
            if (null (tl dates))
                then (hd dates)
            else if (is_older((hd dates),greatest(tl dates)))
                then greatest(tl dates)
                else (hd dates)
    in
        "SOME " ^ date_to_string(greatest(dates))
    end;

oldest([(1995,2,3), (1995,3,3), (1995,4,1), (1995,4,2), (1995,5,3), (1996,4,3)]);
oldest([(1995,2,3)]);
oldest([]);