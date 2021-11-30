

def digitalRoot(number, base):
    if number == 0:
        return 0
    dR = number % (base - 1)
    if dR == 0:
        dR = base - 1
    return dR


def makeLatinSquare(numericSystem):
    rowsToCross = set()
    colsToCross = set()
    #vedicSquare = []
    for i in range(1, numericSystem - 1):
        #line = []
        for j in range(1, numericSystem - 1):
            value = i * j % (numericSystem - 1)
            if value == 0:
                rowsToCross.add(i)
                colsToCross.add(j)
            #line.append(value) #Можно исключить
        #vedicSquare.append(line) #Если ведичиеский квадрат не нужен, а только латинский
    #for i in range(len(vedicSquare)):
        #print(vedicSquare[i])
    #print()
    latinSquare = []
    for i in range(1, numericSystem - 1):
        if i in rowsToCross:
            continue
        line = []
        for j in range(1, numericSystem - 1):
            if j in colsToCross:
                continue
            line.append(i * j % (numericSystem - 1))
        latinSquare.append(line)
    return latinSquare


def findRamainder(numericSystem):
    for i in range(2, numericSystem - 2):
        line = []
        line.append(1)
        for j in range(1, numericSystem - 1):
            value = digitalRoot(i ** j, numericSystem)
            #print(i ,'^', j, '=', value, ' ', end='')
            if value == 1:
                continue
            line.append(value)
        if len(line) == P-1:
            return line



'''
numericSystem = 10 #12 ?7 ? 8
latinSquare = makeLatinSquare(numericSystem) 
print()
print("Latin square")
for i in range(len(latinSquare)):
    print(latinSquare[i])

print()
print("Remainder')
P = 7 #Найти P
rem = findRamainder(P + 1)
print(rem)
print()
'''

from Rational import Rational
r = Rational()
r.calc(1, 17, 10)
r.isCyclic()
m = r.multiplyShift()
v = r.verticalTables()


for i in range(len(v)):
    print(v[i])

print()
print(m)


'''
r.calc(1, 7, 12)
r.isCyclic()
m = r.multiplyShift()

print()
print(m)
'''