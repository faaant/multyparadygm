#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main()
{
    int numIsNeeded = 20, n = 20, index = 0, border;
    int itI = 0, itJ = 0;
    bool flag = true;
    string* words = new string[n];
    int* repeats = new int[n];

    int wordsArrayLength = 0;
    string stopWords[5] = {"the", "for", "in", "on", "a"};

    string word;

    ifstream file("input.txt");
    reading:
        if (!(file >> word)) {
            goto endOfReading;
        }

        index = 0;
        toLowerCase:
            if (!word[index]){
                goto endLowerCase;
            }
            if (word[index]>='A' && word[index]<= 'Z'){
                word[index] += 32;
            }
            index ++;
            goto toLowerCase;
        endLowerCase:

        //check forbidden words
        index = 4;
        checkForbidden:
            if (index<0){
                goto endCheckForbidden;
            }
            if (word==stopWords[index]){
                goto reading;
            }
            index--;
            goto checkForbidden;
        endCheckForbidden:

        //if wordsArrLength >= n  -->  increase n and recomplete arr
        if (wordsArrayLength >= n) {
            string* newWords = new string[wordsArrayLength*10];
            int* newRepeats = new int[wordsArrayLength*10];
            n--;
            whileNnotLessZero:
                if (n<0) {
                    goto lessThanZero;
                }
                newWords[n] = words[n];
                newRepeats[n] = repeats[n];
                n--;
            goto whileNnotLessZero;
            lessThanZero:
            words = newWords;
            repeats = newRepeats;
            n = wordsArrayLength*10;
        }


        //add to arr or increase numOfRepeats
        index = wordsArrayLength-1;
        flag = true;
        if (wordsArrayLength==0){
            words[0] = word;
            repeats[0] = 1;
            wordsArrayLength++;
        } else {
            //check is exist
            isExist:{
                if (index<0){
                    goto endExist;
                }
                if (words[index]==word){
                    repeats[index] += 1;
                    flag = false;
                    goto endExist;
                }
                index--;
                goto isExist;
            }
            endExist:
                if (flag) {
                    words[wordsArrayLength] = word;
                    repeats[wordsArrayLength] = 1;
                    wordsArrayLength++;
                }
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
                if (repeats[itI]>repeats[itJ]){
                    int buf = repeats[itI];
                    repeats[itI] = repeats[itJ];
                    repeats[itJ] = buf;

                    string wordBuf = words[itI];
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
    border = numIsNeeded;
    if (wordsArrayLength<numIsNeeded) {
        border = wordsArrayLength;
    }
    output:
        if (index<border){
            cout << words[index] <<" - " <<repeats[index] <<endl;
            index++;
            goto output;
        }
    file.close();
    return 0;
}
