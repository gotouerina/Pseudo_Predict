##install.packages("Hmisc")
##只用富集到的前几行画图，不然会输出一团黑
##按INGO从大到小排序
library(ggplot2)
library(Hmisc)
go <- read.csv("C:/Users/11974/Desktop/FINALGO.csv",header = T)
x = (go$InGO)
y <- factor(go$Description,levels = rev(unique(go$Description)))  
Gene_number <- go$GeneInGOAndHitList ##这里记得把excel 列表中的GeneInGOAndHitList和InGo前的#删掉，不然会输出空文件
p = ggplot(go,aes(x,y))
p = p + geom_point(aes(size = Gene_number,color = -LogP))
p = p + scale_color_gradient(low = "blue", high = "red")
p = p + labs(color = expression(-log10(P)),size = "Gene counts",x = "Gene Ratio",y = "GO terms",title = "Go enrichment ")
p = p + scale_size_continuous(range = c(4,8))
p

