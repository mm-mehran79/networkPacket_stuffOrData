import random
noOfTest = 10
with open("pm", 'w') as pmFile, open("cm", 'w') as cmFile, open("dors",'w') as dors:
    for testNumber in range(noOfTest):
        pm = random.randint(5,100)
        cm = random.randint(2,pm)
        dors.write('x\n')
        pmFile.write(f"{pm}\n")
        cmFile.write(f"{cm}\n")
        for j in range(1,pm+1):
            pmFile.write('x\n')
            cmFile.write('x\n')
            if( (j * cm) % pm < cm):
                dors.write('1\n')
            else :
                dors.write('0\n')
        
