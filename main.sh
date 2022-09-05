#!/bin/bash

lockfile=/tmp/main.sh.lock
#logfile=/vagrant/access.log
logfile=target_access.log
email=/tmp/email.txt
email_address=nuss@yandex.ru

# while testing reset email
rm $email

# функция для очистки файлов перед выходом
cleanup(){
	echo starting the cleanup
	rm -f $lockfile
#	rm -f $email
}

# провеhяем не запущен ли cкрипт с помощью trap
if [[ -f $lockfile ]]
then
	echo script is already running
	exit 2
fi

# создаем lock 
touch $lockfile

#зачискa перед выходом
trap 'cleanup'  EXIT

# функция для создания письма
to_email(){
	printf "$1" >> $email
}

echo starting the script

# в процессе провиженинга был скачан рублично доступный access.log файл 
# из http://www.almhuette-raith.at/apache-log/access.log.

# выберем из него только интересующие нас данные.
# посколько мы запускаем скрипт раз в час, возьмем из файла данные только за предыдущий час
# с учетом, что это файл из другой временной зоны (UTC+2) будем отнимать 2 часа от текущей даты

ayear=`date --date="2 hour ago" +%Y`
amonth=`date --date="2 hour ago" +%b`
aday=`date --date="2 hour ago" +%d`
ahour=`date --date="2 hour ago" +%H`

grep -E "$aday/$amonth/$ayear:$ahour" /home/vagrant/access.log > $logfile

# опишем какой период времени обработатываем
to_email "\n\nСтатистика работы nginx за час: $aday/$amonth/$ayear $ahour:00 - $ahour:59 (UTC)"

to_email "\n\nСписок IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта:\n"

to_email "`cut -f 1 -d ' ' $logfile | sort | uniq -c | sort -nr | head -n 20`"
#printf "`cut -f 1 -d ' ' $logfile | sort | uniq -c | sort -nr | head -n 20`" >> $email

to_email "\n\nСписок запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта:\n"

to_email "`cut -d ' ' -f 7 $logfile | sort | uniq -c | sort -nr | head -n 20`"

to_email "\n\nОшибки веб-сервера/приложения c момента последнего запуска:\n"

to_email "`grep -vP '\" 2\d\d ' $logfile | awk '{print $9,$1,$4,$5,$6,$7,$8}'`"

to_email "\n\nСписок всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта:\n"

to_email "`awk '{print $9}' $logfile | sort | uniq -c | sort -rn`"

# отправляем письмо

cat $email | mutt -s "webserver stat" $email_address


