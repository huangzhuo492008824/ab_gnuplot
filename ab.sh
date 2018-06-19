total=3000
for var in {100,500}
do
    ab -g dat/$var.dat -r -c ${var} -n ${total}  http://127.0.0.1:7010/
    sleep 10
done
