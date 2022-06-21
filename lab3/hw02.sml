(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option (s : string, sList : string list) =
  case sList of 
  [] => NONE 
  | shifted_el::arr => case same_string(s, shifted_el) of
        true => SOME(arr) 
        | false => case all_except_option(s, arr) of
               NONE => NONE | SOME resArr => SOME(shifted_el::resArr);

fun get_substitutions1(listOfLists: string list list, s: string) =
  case listOfLists of
  [] => [] 
  | shifted_arr::arr => case all_except_option(s,shifted_arr) of
     NONE => get_substitutions1(arr, s) 
     | SOME arrWithoutS => arrWithoutS @ get_substitutions1(arr,s);

fun get_substitutions2(listOfLists: string list list, s: string) =
   let fun f(acc: string list list, s: string) = 
      case listOfLists of
      [] => [] 
      | shifted_arr::arr => case all_except_option(s,shifted_arr) of
         NONE => get_substitutions1(arr, s) 
         | SOME arrWithoutS => arrWithoutS @ get_substitutions1(arr,s);
   in
      f(listOfLists,s)
   end


   
fun similar_names(listOfLists: string list list, fullName:{first:string,middle:string,last:string}) =
    let 
        val {first=f,middle=m,last=l} = fullName
        val array = f::get_substitutions1(listOfLists,f)
        fun f (array: string list) =
            case array of [] => []
            | shifted_el::arr => {first=shifted_el, middle=m, last=l}::f(arr)
    in
        f(array)
    end;
similar_names([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],{first="Fred", middle="W", last="Smith"});

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color (c : card) = 
      case c of
         (s,r) => case s of 
         Clubs => Black
         | Diamonds => Red
         | Hearts => Red
         | Spades => Black;

card_color((Clubs, Jack));

fun card_value (c : card) = 
   case c of
      (s,r) => case r of 
      Jack => 10
      | Queen => 10
      | King => 10
      | Ace => 11
      | Num v => v;

card_value((Clubs, Jack));
card_value((Clubs, Num 8));

fun remove_card (cs: card list, c : card, e) = 
   case cs of 
      [] => raise e
      | ca::cs' => if ca=c then cs' else remove_card(cs',c,e);

remove_card([(Hearts, Ace), (Diamonds, Num 3), (Hearts, Ace)], (Hearts,Ace), IllegalMove);

fun all_same_color (cs : card list) = 
   case cs of 
   [] => true
   | el::cs' => case cs' of
      [] => true 
      | el'::cs'' => if card_color(el)=card_color(el') then all_same_color(cs') else false;

all_same_color([(Hearts, Ace), (Diamonds, Num 3), (Hearts, Ace)]);
all_same_color([(Spades, Ace), (Spades, Num 3), (Clubs, Ace)]);
all_same_color([(Clubs, Ace), (Hearts, Ace), (Diamonds, Num 3)]);
all_same_color([(Spades, Ace), (Diamonds, Num 3), (Clubs, Ace)]);
all_same_color([(Spades, Ace)]);
all_same_color([(Spades, Ace), (Diamonds, Num 3)]);

fun sum_cards (cs : card list) = 
   let 
      fun summator(arr : card list) = 
         case arr of 
            [] => 0
            | el::arr' => card_value(el) + summator(arr')
   in
      summator(cs)
   end;

sum_cards([(Hearts, Ace), (Diamonds, Num 3), (Hearts, Ace)]);

fun score (cs : card list, goal : int) = 
   let 
      fun findFirstScore(cs', goal') = 
         if (sum_cards(cs') > goal')
            then 3*(sum_cards(cs')-goal')
            else goal'-sum_cards(cs');
   in
      if (all_same_color(cs))
         then findFirstScore(cs, goal) div 2 
         else findFirstScore(cs,goal)
   end;

score([(Hearts, Ace), (Diamonds, Num 3), (Hearts, Ace)], 10);
score([(Hearts, Ace), (Diamonds, Num 3), (Spades, Ace)], 10);