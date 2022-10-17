
def main(input):
    with open(input,"r") as f:
        for line in f:
            if line.startswith("HSP"):
                continue
            if line.startswith(">"):
                CHR = line.strip().split(">")[1]
            else:
                content = line.strip().split()
                content[0] = CHR
                print("%s %s %s" %(content[0],content[11],content[12]))
                #print("\t".join(content))

if __name__ == "__main__":
    #input = "que.bed"
    input = "Ecansus.pep.gba.report"
    main(input)
