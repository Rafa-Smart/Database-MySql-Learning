n = int(input('Masukan jumlah perkalian: '))

i = 1
while i <= n:
    j = 1
    while j <= n:
        print(f'{i * j}'.rjust(4), end=' ')
        j += 1
    print()
    i += 1