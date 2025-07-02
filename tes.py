i = 0
star = ''


while i < 6:
    star += '*'
    print(' ' * (6 - len(star)) + star)
    i = i + 1


i = 5
while i > 0:
    star = '*' * i
    print(' ' * (6 - len(star)) + star)
    i = i - 1