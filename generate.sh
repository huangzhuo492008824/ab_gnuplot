#!/bin/bash
# author hikdo

c=500
n=10000
url="http://127.0.0.1:9005/"
app=""

app_version=("old")

for v in ${app_version[@]};do
	  echo app-${v}
	    read -p "switch app version to continue ..."
	      rm -f dat/${app}_${v}.tsv log/${app}_${v}.log
	        ab -c ${c} -n ${n} -g dat/${app}_${v}.tsv ${url} | tee log/${app}_${v}.log
	done

	# draw response time
	echo "set terminal png" > plot
	echo "set output \"img/${app}_response_time.png\"" >> plot
	echo "set title \"${app} version perform\"" >> plot
	echo "set size 1,1" >> plot
	echo "set grid" >> plot
	echo "set xdata time" >> plot
	echo "set timefmt \"%s\"" >> plot
	echo "set format x \"%S\"" >> plot
	echo "set xlabel \"Seconds\"" >> plot
	echo "set ylabel \"Response time (ms)\"" >> plot
	echo "set datafile separator '\t'" >> plot

	plotArgs="plot "
	i=0;
	for v in ${app_version[@]}
	do
		  let i++
		    plotArgs=${plotArgs}" \"dat/${app}_${v}.tsv\" every ::2 using 2:5 title \"app-${v}\" with points"
		      if [ $i -lt ${#app_version[*]} ]; then
			          plotArgs=${plotArgs}","
				    fi
			    done
			    echo ${plotArgs} >> plot
			    gnuplot plot
			    rm -f plot
			    echo "draw response time done."

			    # draw qps
			    echo "drawing qps..."
			    echo "set terminal png" > qps
			    echo "set output \"img/${app}_qps.png\"" >> qps
			    echo "set title \"${app} version perform\"" >> qps
			    echo "set size 1,0.7" >> qps
			    echo "set grid" >> qps
			    echo "set xlabel \"app version\"" >> qps
			    echo "set ylabel \"qps\"" >> qps
			    echo "set yrange [0:5000]" >> qps
			    echo "set style data histograms" >> qps
			    echo "set style fill solid 1.00 border -1" >> qps
			    plotArgs="plot \"dat/qps.tsv\" using 2:xtic(1) title \"qps\""
			    rm -f dat/qps.tsv
			    for v in ${app_version[@]}
			    do  
				      qps=$(sed -n "s/.*Requests per second:    \([0-9\.]*\).*/\1/p" log/${app}_${v}.log)
				        echo "app-${v} ${qps}" >> dat/qps.tsv
				done
				echo ${plotArgs} >> qps
				gnuplot qps
				echo "all done."
