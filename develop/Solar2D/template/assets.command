bookname=book01
cp ~/Documents/Kwik/BookServer/copyright.txt ../build4/assets/copyright.txt
cp ../build4/model.json  ../build4/assets/model.json
cp ../*.mp3 ../build4/assets/audios/
cp ../*.txt ../build4/assets/audios/
cd ../build4
mv assets $bookname
zip -r ../assets.zip $bookname
mv $bookname assets
cd ../tmplt