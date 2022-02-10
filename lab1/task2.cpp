#include <iostream>
#include <string>
#include <fstream>
using namespace std;

struct Word {
    string text;
    string pages;
    int repeats;
    int lastRepeatPage;
};

//if word is on the border as example word starts at 1795 symbol and ends on 1805 symbol then it will bi added to page
//on which starts
int main()
{
    int n = 20, index = 0, pageSymbols = 0, currentPage=1, itI = 0, itJ = 0;
    int wordsArrayLength = 0;
    bool flag = true;
    string newWord = "", word;
    Word* words = new Word[n];
    ifstream file("input.txt");
    reading:
        if (!(file >> word)) {
            goto endOfReading;
        }

        if (word == "-"){
            pageSymbols+=2;
            goto reading;
        }

        index = 0;
        newWord = "";
        toLowerCase:
            if (!word[index]){
                goto endLowerCase;
            }
            if (word[index]>='A' && word[index]<= 'Z'){
                word[index] += 32;
            }

            if (word[index]>='a' && word[index] <= 'z') {
                newWord += word[index]; // to remove "hello." -> "hello"
            }
            index ++;
            goto toLowerCase;
        endLowerCase:
            word = newWord;
            pageSymbols+= index + 1;

        //if wordsArrLength >= n  -->  increase n and recomplete arr
        if (wordsArrayLength >= n) {
            Word* newWords = new Word[wordsArrayLength*10];
            n--;
            whileNnotLessZero:
                if (n<0) {
                    goto lessThanZero;
                }
                newWords[n] = words[n];
                n--;
            goto whileNnotLessZero;
            lessThanZero:
            words = newWords;
            n = wordsArrayLength*10;
        }


        //add to arr or increase numOfRepeats
        index = wordsArrayLength-1;
        flag = true;
        if (wordsArrayLength==0){
            words[0].text = word;
            words[0].repeats = 1;
            words[0].pages = to_string(currentPage);
            words[0].lastRepeatPage = currentPage;
            wordsArrayLength++;
        } else {
            //check is exist
            isExist:{
                if (index<0){
                    goto endExist;
                }
                if (words[index].text==word){
                    words[index].repeats += 1;
                    if (words[index].lastRepeatPage != currentPage) {
                        words[index].pages+= ", " + to_string(currentPage);
                        words[index].lastRepeatPage = currentPage;
                    }
                    flag = false;
                    goto endExist;
                }
                index--;
                goto isExist;
            }
            endExist:
                if (flag) {
                    words[wordsArrayLength].text = word;
                    words[wordsArrayLength].repeats = 1;
                    words[wordsArrayLength].pages = to_string(currentPage);
                    words[wordsArrayLength].lastRepeatPage = currentPage;
                    wordsArrayLength++;
                }
        }
        if (pageSymbols >= 1800) {
            currentPage++;
            pageSymbols = pageSymbols-1800;
        }
    goto reading;
    endOfReading:

    //sort by repeats
    itI = 0;
    sorting: {
        if (itI>=wordsArrayLength) {
            goto endOfSorting;
        }
        itJ = 0;
        cyclJ:
            if (itJ<wordsArrayLength){
                if (words[itI].text<words[itJ].text){
                    Word wordBuf = words[itI];
                    words[itI] = words[itJ];
                    words[itJ] = wordBuf;
                }
                itJ++;
                goto cyclJ;
            }
        itI++;
        goto sorting;
    }
    endOfSorting:

    index = 0;
    output:
        if (index<wordsArrayLength){
            if (words[index].repeats <= 100){
                cout << words[index].text <<" - " <<words[index].pages <<endl;
            }
            index++;
            goto output;
        }
    file.close();
    return 0;
}
