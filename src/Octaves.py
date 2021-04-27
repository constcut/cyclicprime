import time

from fractions import gcd


def listToStr(scaleList):
    result = ''
    for el in scaleList:
        result += str(el) + ' '
    return result


def calculateOctaveScales(firstStep, n, type='lists'): #todo *3 penatonic also
    scales = []
    import gmpy2
    currentStep = gmpy2.mpz(firstStep)
    prevSize = len(str(currentStep)) 
    anotherScale = []
    for i in range(n*7):
        if i % int(n*7/10) == 0:
            print(i, " elements ",i/7," scales")
        currentStep *= 2
        currentSize = len(str(currentStep))
        if currentSize == prevSize:
            anotherScale.append(2)
        else:
            anotherScale.append(1)
        prevSize = currentSize
        if len(anotherScale) == 7:
            if type == 'lists':
                scales.append(anotherScale)
            elif type == 'names':
                scales.append(translateScaleName(listToStr(anotherScale)))
            elif type == 'numbers':
                scales.append(getScaleNumber(listToStr(anotherScale)))
            anotherScale = []
    return scales

def translateScaleName(scale):
    scale = scale.strip()
    if scale=="2 2 1 2 2 2 1": return "Ionian major"
    elif scale=="2 1 2 2 2 1 2": return "Dorian minor"
    elif scale=="1 2 2 2 1 2 2": return "Frigian minor"
    elif scale=="2 2 2 1 2 2 1": return "Lidian major"
    elif scale=="2 2 1 2 2 1 2": return "Miksolidian major"
    elif scale=="2 1 2 2 1 2 2": return "Eolian minor"
    elif scale=="1 2 2 1 2 2 2": return "Lokrian"
    elif scale=="1 2 2 1 2 2 1": return "Symmetric 11"
    elif scale =="2 2 3 2 3": return "Major pent."
    elif scale =="3 2 2 3 2": return "Minor pent."
    return scale

def getScaleNumber(scale): #numbers according to how they appear in 1/7 also can make for start 14*2 octave
    scale = scale.strip()
    if scale=="2 2 1 2 2 2 1": return 0
    elif scale=="2 1 2 2 2 1 2": return 2
    elif scale=="1 2 2 2 1 2 2": return 4
    elif scale=="2 2 2 1 2 2 1": return 6
    elif scale=="2 2 1 2 2 1 2": return 1
    elif scale=="2 1 2 2 1 2 2": return 3
    elif scale=="1 2 2 1 2 2 2": return 7
    elif scale=="1 2 2 1 2 2 1": return 5
    return -1

def getScaleNameByNumber(scaleNumber):
    if scaleNumber==0: return "Ionian major"
    elif scaleNumber==2: return "Dorian minor"
    elif scaleNumber==4: return "Frigian minor"
    elif scaleNumber==6: return "Lidian major"
    elif scaleNumber==1: return "Miksolidian major"
    elif scaleNumber==3: return "Eolian minor"
    elif scaleNumber==7: return "Lokrian"
    elif scaleNumber==5: return "Symmetric 11"
    return 'unknown_scale#' + str(scaleNumber)

def getScaleFormulaByNumber(scaleNumber):
    scaleNumber = int(scaleNumber)
    if scaleNumber==0: return "2 2 1 2 2 2 1"
    elif scaleNumber==2: return "2 1 2 2 2 1 2"
    elif scaleNumber==4: return "1 2 2 2 1 2 2"
    elif scaleNumber==6: return "2 2 2 1 2 2 1"
    elif scaleNumber==1: return "2 2 1 2 2 1 2"
    elif scaleNumber==3: return "2 1 2 2 1 2 2"
    elif scaleNumber==7: return "1 2 2 1 2 2 2"
    elif scaleNumber==5: return "1 2 2 1 2 2 1"
    else: return 'unknown_scale#' + str(scaleNumber)

#
def getScaleNameFromList(scaleNumber, scalesNames):
    for scale, index in scalesNames:
        if scaleNumber == index:
            return translateScaleName(scale)
    return 'unknown_scale#' + str(scaleNumber)

def compareScaleFormulas(formula1, formula2):

    if formula1 == formula2:
        return 0
    semiTones1 = [] 
    semiTones2 = []
    steps1 = formula1.split()
    steps2 = formula2.split() 
    for i in range(len(steps1)):
        if steps1[i] == '1':
            semiTones1.append(i)
        if steps2[i] == '1':
            semiTones2.append(i)

    if len(semiTones1) == len(semiTones2) and len(semiTones1) == 2: 
        firstAreEqual = False
        secondAreEqual = False
        directionSecond = 0
        directionFirst = 0
        if semiTones1[0] == semiTones2[0]:
            firstAreEqual = True
        else:
            directionFirst = semiTones1[0] - semiTones2[0]

        if semiTones1[1] == semiTones2[1]:
            secondAreEqual = True
        else:
            directionSecond = semiTones1[1] - semiTones2[1]

        if firstAreEqual and secondAreEqual == False:
           return directionSecond*2
        if secondAreEqual and firstAreEqual == False:
           return directionFirst
        if firstAreEqual == False and secondAreEqual == False:
           if directionFirst != directionSecond:
               print("Some issue(dirrections are opposite): ",directionFirst,directionSecond) 
               return 4
           return directionFirst*3
    else: 
        if formula1 == '1 2 2 1 2 2 2' and formula2 == '1 2 2 1 2 2 1':
            return 5
        if formula1 == '1 2 2 1 2 2 1' and formula2 == '2 2 2 1 2 2 1':
            return 6
        if formula1 == '1 2 2 1 2 2 1' and formula2 == '2 2 1 2 2 2 1':
            return 7
        print("CASE 8: ", len(semiTones1), len(semiTones2),'formulas' ,formula1,' : ' ,formula2)
        return 8
    return 9

def describeCompareScaleResult(compareResult):
    if compareResult == 0: return 'Scales are equal'
    elif compareResult == 1: return 'First interval shifted'
    elif compareResult == -1: return 'First interval shifted (reversed)'
    elif compareResult == 2: return 'Second interval shifted'
    elif compareResult == -2: return 'Second interval shifted (reversed)'
    elif compareResult == 3: return 'Both intervals shifted'
    elif compareResult == -3: return 'Both intervals shifted (reversed)'
    elif compareResult == 4: return 'Big unknown difference but only 2 intervals'
    elif compareResult == 5: return '3 intervals scale appear, octave not finised'
    elif compareResult == 6: return '3 intervals scale leave, key shifted (a)'
    elif compareResult == 7: return '3 intervals scale leave, key shifted (b)'
    elif compareResult == 8: return 'NOT 2 intervals some unknown'
    elif compareResult == 9: return 'Some unexpected case'
    return 'UnknownCR' + str(compareResult)


def exploreScalesInSequence(sequenceString): 
    scalesNumbers = sequenceString.split()
    for i in range(1, len(scalesNumbers)):
        prevScale = getScaleFormulaByNumber(scalesNumbers[i-1])
        currentScale = getScaleFormulaByNumber(scalesNumbers[i])
        compareResult = compareScaleFormulas(prevScale,currentScale)
        print("Compare result ",compareResult, ' on ', i, describeCompareScaleResult(compareResult))

def compareScalesBetweenSequences(seqString1, seqString2):
    scalesNumbers1 = seqString1.split()
    scalesNumbers2 = seqString2.split()
    scale1 = getScaleFormulaByNumber(scalesNumbers1[-1])
    scale2 = getScaleFormulaByNumber(scalesNumbers2[0])
    compareResult = compareScaleFormulas(scale1,scale2)
    print("Compare result ",compareResult, describeCompareScaleResult(compareResult))


def findSequences(scalesList):
    sequences = []
    seqNumbers = {}
    seqCounter = 0
    newSeq = []
    for scale in scalesList:
        if scale == 0 and len(newSeq) > 0:
            currentSeqInd = 0
            seqStr = listToStr(newSeq)
            if seqNumbers.get(seqStr) != None:
                currentSeqInd = seqNumbers[seqStr]
            else:
                seqNumbers[seqStr] = seqCounter
                currentSeqInd = seqCounter
                seqCounter += 1
            sequences.append(currentSeqInd)
            newSeq = []
        newSeq.append(scale)
    return sequences, seqNumbers 


def digitSpectrumFromStr(inputStr):
    elements = inputStr.split() 
    spectrum = [0] * 10 
    for el in elements:
        if el.isdigit():
            spectrum[int(el)] += 1
    return spectrum

def digSpecDiff(digSp1, digSp2): 
    for i in range(len(digSp1)):
        if digSp1[i] != digSp2[i]:
            return i

def compareSequences(seqNames): 
    longestIndex = '' 
    longestValue = 0
    compareResults = []
    for name, value in seqNames.items():
        currentLength = len(str(name))
        if currentLength > longestValue:
            longestValue = currentLength
            longestIndex = name

    foundSet = set(longestIndex.split())
    shorterButFull = []
    for name, value in seqNames.items():
        currentSet = set(name.split())
        if currentSet == foundSet:
            if name != longestIndex:
                shorterButFull.append(name)

    fullSequence = shorterButFull[0]
    if len(shorterButFull) > 1:
        print("Found more then shorter but full value ", shorterButFull)
        expectedIndex = -1
        maxLen = 0
        for i in range( len(shorterButFull) ):
            checkName = shorterButFull[i]
            if len(checkName.split()) > maxLen:
                maxLen = len(checkName.split())
                expectedIndex = i
        fullSequence = shorterButFull[expectedIndex]
        print("Solution is ",fullSequence)


    protoSpectrum = digitSpectrumFromStr(shorterButFull[0])
    print("Table: ")
    print(shorterButFull[0], ' the prototype')
    for name, value in seqNames.items():
        if name == shorterButFull[0]:
            pass 
        elif name == longestIndex:
            diffIndex = shorterButFull[0].find('0')
            diffStrList = list(shorterButFull[0])
            diffStrList[diffIndex] = '_' 
            diffStr = "".join(diffStrList)
            compareResults.append((0, value))
            print(diffStr, ' (', 0, ') #',value,getScaleNameByNumber(0))
        else:
            currentSpectrum = digitSpectrumFromStr(name) 
            diff = digSpecDiff(protoSpectrum,currentSpectrum) 
            diffIndex = shorterButFull[0].find(str(diff))
            diffStrList = list(shorterButFull[0])
            diffStrList[diffIndex] = '_' 
            diffStr = "".join(diffStrList)
            print(diffStr,' (', diff, ') #',value, getScaleNameByNumber(diff))
            compareResults.append((diff, value))
    return compareResults


def findGroupsByPattern(sourceList, patternList):
    groups = []
    groupNumbers = {}
    groupCounter = 0
    templateStr = listToStr(patternList)
    prevBeginInd = 0
    for i in range(len(sourceList) - len(patternList)):
        subList = sourceList[i:len(patternList)+i] 
        subStr = listToStr(subList)
        if templateStr == subStr:
            group = sourceList[prevBeginInd:i-1]
            groupStr = listToStr(group)
            prevBeginInd = i
            currentGroupInd = 0
            if groupNumbers.get(groupStr) != None:
                currentGroupInd = groupNumbers[groupStr]
            else:
                currentGroupInd = groupCounter
                groupNumbers[groupStr] = groupCounter
                groupCounter += 1
            groups.append(currentGroupInd)
    return groups, groupNumbers


