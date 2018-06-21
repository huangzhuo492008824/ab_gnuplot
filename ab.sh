for total in 1000 2000 5000
do
    for var in 100 200 500 
        do
            ab -g dat/uwsgi_n$total-c$var.dat -r -c $var -n $total  http://127.0.0.1:7010/
            sleep 10
            ab -g dat/gunicorn_n$total-c$var.dat -r -c $var -n $total  http://127.0.0.1:7015/
            sleep 10
        done
done
