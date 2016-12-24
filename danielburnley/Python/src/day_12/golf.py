def execute(a,b):
 p=0
 while p<len(a):
  i=a[p]
  c=i[0]
  if c==0:b[i[2]]=int(i[1])if i[1] not in b else b[i[1]]
  if c==1:b[i[1]]+=1
  if c==2:b[i[1]]-=1
  if c==3:p+=i[2]if i[1]not in b and i[1]!=0 else 1 if b[i[1]]==0 else int(i[2])if i[2]not in b else b[i[2]]
  if c!=3:p+=1
 return b