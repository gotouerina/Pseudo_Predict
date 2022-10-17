def jiajiyin(input):
    with open (input,"r") as a:
        for line in a:
            if line.startswith("Protein"):
                chrom = line.strip().split()[1]
                print ("%s" %chrom)
            else:
                continue

if __name__=="__main__":
    input = "Ecansus.pep.genewise.out"
    jiajiyin(input)
