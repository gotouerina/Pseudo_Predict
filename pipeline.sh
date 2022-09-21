#使用前conda安装genblastA genewise,gffread,seqkit
#dnafasta为mask过的fasta序列
proteinfasta=
dnafasta=
gff1=

PATH:"$PATH":/data/01/user214/jiajiyin
export $PATH
##手动下载BLAST2002的库，将formatdb所在的文件夹添加到环境变量中

export WISECONFIGDIR=/data/01/user214/jiajiyin/wise2.4.1/wisecfg  
##此处修改genewise工作路径

genblasta -P blast -pg tblastn -q $proteinfasta -t $dnafasta  -p T -e 1e-5 -g T -f F -a 0.5 -d 100000 -r 10 -c 0.5 -s 0
##同源序列比对

awk -v OFS="\t" '{if($11==1) print $7,"geneblasta","CDS",$8,$9,".","+","1","ID="$7":"$8"-"$9;else print $7,"geneblasta","CDS",$8,$9,".","-","1","ID="$7":"$8"-"$9}'  $proteinfasta.gba.report > $proteinfasta.gff
cat $proteinfasta.gff | sed -e '/\:\-/d' > $proteinfasta.gff2
gffread $proteinfasta.gff2 -g $dnafasta -x $proteinfasta.cds
seqkit translate $proteinfasta.cds > $proteinfasta.pro

###sed -i 's/GS\.LG/chr/g' $proteinfasta.pro
##genewise只识别15字符串以内的染色体名字，此处替换名字

genewisedb  -prodb  $proteinfasta.pro -dnadb $proteinfasta.cds -pseudo -gff > $proteinfasta.genewise.out
##假基因预测

python jiajiyin > $proteinfasta.in
sed -i '1d ' $proteinfasta.in

###sed -i 's/chr/GS\.LG/g' $proteinfasta.in
##同上，此处将名字替换回来

##leyan test
##cat $proteinfasta.in| tr -s ':' '\t' | tr -s '-' '\t' > $proteinfasta.bed
##cat $proteinfasta.bed | awk '$4=$4"\tpseudo"' > $proteinfasta.1.bed
##cat $proteinfasta.1.bed | tr -s ' ' '\t' > $proteinfasta.2.bed

cat  $proteinfasta.in | tr -s ':' '\t' | tr -s '-' '\t' | awk '$4=$4"\tpseudo"'  | tr -s ' ' '\t' > $proteinfasta.2.bed

cat $gff1 | awk '{print $1,"\t",$4."\t",$5,"\t",$9} ' > $gff1.bed
cat $proteinfasta.2.bed $gff1.bed > $gff1.input.bed

###cat test.bed | sed -e '/\[/d' >test1.bed
###sort -k1,1 -k2,2n test1.bed > test2.bed

cat $gff1.input.bed | sed -e '/\[/d' | sort -k1,1 -k2,2n > $gff1.input.bed

##合并两个bed
bedtools merge -i test2.bed  -c 1,4 -o count > $gff1.out1.bed

##最终输出
cat $gff1.out1.bed | grep 'pseudo' | sed  's/pseudo\,//g'  > $gff1.out2.bed
