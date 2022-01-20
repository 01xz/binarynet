for i in range(1, 1024 + 1):
  print('%04X'%(i - 1), end = ' ')
  if i % 32 == 0:
    print('')
