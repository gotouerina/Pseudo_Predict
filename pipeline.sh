#使用前conda安装genblastA genewise,gffread，bedtools
#使用前记得修改python中对应的输入文件名
#dnafasta为mask过的fasta序列
proteinfasta=
dnafasta=
gff1=
PATH="$PATH":/data/01/user214/jiajiyin
export PATH
##手动下载BLAST2002的库，将formatdb所在的文件夹添加到环境变量中
export WISECONFIGDIR=/data/01/user214/jiajiyin/wise2.4.1/wisecfg  
##此处修改genewise工作路径
genblastA -P blast -pg tblastn -q $proteinfasta -t $dnafasta  -p T -e 1e-5 -g T -f F -a 0.5 -d 100000 -r 10 -c 0.5 -s 0
##同源序列比对
##提取DNA
cat $proteinfasta.gba.report | awk -F ' '  '$2>95 {print $7,$8,$9}' | tr -s ' ' '\t'  | sed -e '1d' >  $proteinfasta.dna.bed
bedtools getfasta -fi $proteinfasta -bed $proteinfasta.dna.bed -fo $proteinfasta.pro.fasta
####对BLAST结果的蛋白进行提取
##python脚本改一下输入文件名
python3 pro.py | awk -F ' '  '$2>95 {print $1,$3,$4}' | tr -s ' ' '\t' > $proteinfasta.pro.bed
bedtools getfasta -fi $proteinfasta -bed $proteinfasta.pro.bed -fo $proteinfasta.pro.fasta
genewisedb  -prodb  $proteinfasta.pro.fasta -dnadb $proteinfasta.cds -pseudo -gff > $proteinfasta.genewise.out
##假基因预测
python jiajiyin.py > $gff1.pseudo.list 
cat $gff1.pseudo.list | sort | uniq > $gff1.pseudo.output
python gene.py  | sed 's/DNA//g' | sed -e '1d' | sort | uniq > $gff1.gene.list