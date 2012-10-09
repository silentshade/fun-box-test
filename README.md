fun-box-test
============

Level I

Q1: Какие сторонние библиотеки вы используете чаще всего для разработки. Какие 
плюсы в них вы выделяете для себя?
В нашем проекте основная разработка велась как раз на RoR. Поэтому используются библиотеки специфичные для RoR, а также во вложении наш Gemfile. Все плюсы и минусы данных библиотек описывать будет слишком долго, скажу лишь что все они облегчают выполнение тех или иных задач в рамках приложения.
Что касается не RoR ruby проектов, то на данный момент (если не считать правки сторонних gem-ов), я написал только одно приложение для нашего проекта: ruby враппер для конвертации видео с использованием mencoder. Приложение реализует логику выбора параметров конвертации видео, их перемещение по соответствующим папкам, ответы Front-end серверу и т.д.
В этом проекте из сторонних библиотек использовались:
dalli - для работы с memcached (в рамках самописной библиотеки реализующей очередь задач)
yaml - для чтения конфигурационного файла
json - парсинга/генерации JSON кода, как основного формата общения с Front-end сервером
net/http - для установки соединения и использования RESTfull стиля коммуникации с Front-end
uri - для парсинга url

Q2: При работе в команде, каким бы местам в разработке, вы бы уделили большее 
внимание? Какие бы соглашения (Coding Conventions) вам бы помогли в командной 
разработке?
Честно говоря все очень зависит от конкретной ситуации. Если используется фреймворк, то однозначно в первую очередь соблюдение соглашений языка Ruby и во вторую очередь - данного фреймворка. Если в проекте используются сторонние сервера/библиотеки, командой могут быть выработаны дополнительные соглашения об именованиях и т.д. Как мне кажется соглашения должны быть выработаны в рамках одной команды. Общие положения наверное такие: код должен быть интуитивно понятным, названия методов, функций, классов - говорящими сами за себя, краткое описание перед каждым из них (включая типы возможных аргументов и возвращаемых значений).

Q3: Вы когда-нибудь писали в функциональном стиле на Ruby? Если да, то какие сильные 
и слабые стороны есть у данного подхода?
На ruby не писал (вернее иногда использовались лямбды и процедуры в нашем проекте но это все..). В основном этот подход применялся в javascript. Если не углубляться в вопрос, к плюсам отнесу уменьшенный объем кода и хорошую читаемость (в случае если подход правильно применен). К минусам - в некоторых случаях сложность дебага (при использовании аноноимных функций)

Q4: Расскажите об используемых Вами фреймворках (программных каркасах). В чем их 
плюсы? Для каких задач лучше использовать существующий фреймворк, а когда 
лучше все написать самому?
Использовал только Rails.  Написать все самому лучше в случаях:
1) Позволяют ресурсы (в т.ч. и временные) писать все самому
2) Архитектура проекта не подходит под архитектуру/подход фреймворка
3) Вас не устраивает производительность фреймворка или оверхед на операциях в жертву универсальности
во всех остальных случаях считаю что следует использовать фреймворк, дабы не изобретать велосипед. Как показывает практика фреймворки при необходимости допиливают и используют в высоко нагруженных проектах.

Q5: Какие инструменты для профайлинга и дебага вы используете? Какие у них 
минусы? Какие продукты вы использовали для профайлинга и дебага сетевых 
приложений?
Для дебага приложения на RoR:  gem debugger, time, Benchmark, logger.info, puts ну и конечно инструменты разработчика в Chrome, Firebug в Firefox, Dragonfly в Opera и DebugBar в ie. Фронтенд нашего проекта достаточно прост в архитектуре, BDD по этой причине (а так же по причине нехватки ресурсов) не использовался..
Для профилирования ruby-perf, oink, NewRelic
Немного использовал fiddler при работе с Flash (смотрел трафик )
Для тестирования нагрузки и дебага сетевых проблем: ab, siege, tcpdump

Q6: Какие плюсы и минусы есть у системы обработок ошибок в Ruby?
К сожалению мне особо не с чем сравнивать (кроме PHP, но там совсем другая система). К плюсам пожалуй отнесу общую логичность системы, наличие блока ensure, возможность как явно указать класс перехватываемой ошибки, так и перехватывать все в одном блоке. К минусам могу отнести некоторую громоздкость конструкции (хотя для простых случаев есть сокращенный вариант a  = 1/0 rescue "Division by zero!"), и сложности при работе с потоками..

Q7: На каких языках программирования вы дополнительно пишите код?
Неплохо пишу на php и javascript (jquery)
Хуже на perl, sh, powershell

Level II

Q1: Объясните почему происходит следующее:
a) 1660 / 100 ≠ 16.6 
Потому что метод / применяется к классу Fixnum < Integer, а 16.6 является Float < Numeric. Для того что бы получить правильный результат нужно применять метод к Float: 1660.0 / 100

b) 24.0 * 0.1 ≠ 2.4
Это происходит из-за неточности представления чисел с плавающей точкой в двоиной системе. Как правило вычисления с плавающей точкой проводятся с большим числом разрядов, а конечный резудьтат округляется до меньшего числа разрядов.. Так в этом примере нужно округлить до 1го разряда после точки: (24.0 * 0.1).round(1)

Q2: Нужно написать прослойку между почтовым сервером и front-end приложением 
(Flash AS3 Application). Опишите следующие моменты: 
a) Какой формат обмена данными вы бы использовали, для минимального трафико-обмена?
Буду использовать JSON

b) В чем плюсы выбранного вами формата?
Общепринятый стандарт, минимальный оверхед

c) Какие бы технологии вы использовали?
Я с AS3 не работал, поэтому мне не совсем понятнен вопрос..

Q3: Объясните в чем разница в использовании тредов (threads) и форков (forks). В каких случаях, какой вариант более предпочтительный для использования? Как можно профилировать и проводить дебаг приложений с использованием тредов?
Threads - паралельные потоки выполнения кода в контексте одного процесса. Потоки используют единое адресное пространство. Как следствие глобальные переменные доступны всем тредам.
Fork - отдельный процесс зависимый от родителя на уровне ОС. Форк использует таблицу страниц памяти скопированную с процесса родителя.
Вообще вопрос многопоточного выполнения в ruby весьма обширный.
Есть несколько production реализацтя ruby, наиболее известные это MRI, JRuby, Rubinius
Если говорить о ruby MRI, то начиная с версии 1.8.7 реализованы т.н. Green threads. Green threads - это потоки планированием которых занимается виртуальная машина руби, ОС же назначает только один поток для выполнения этого приложения.
В ruby 1.9 релизованы потоки на уровне ОС. Однако тут узким местом становится GIL (Global interpreter Lock).
В JRuby не используется GIL поэтому, там потоки могут быть использованы в полной мере для достижения параллелизма..

Level III

Q1: У вас есть массив целых чисел. Все числа идут последовательно от 1 до k. Но в массиве пропущены 2 числа. Реализуйте алгоритм для нахождения этих чисел.
Код в array_finder.rb

1.9.3p194 :868 > arr = []
 => [] 
1.9.3p194 :869 > (1..10000000).each{|i| arr << i unless i == 7876150 || i == 9785432}
 => 1..10000000 
1.9.3p194 :870 > arr.finder
 => [7876150, 9785432] 
1.9.3p194 :871 > Benchmark.measure{ arr.finder }
 =>   0.000000   0.000000   0.000000 (  0.000065)
1.9.3p194 :872 > Benchmark.measure{ arr.finder2 }
 =>  11.400000   0.800000  12.200000 ( 83.954677)

Q2: Какие нюансы в работе виртуальной машины Ruby вы знаете? Какие оптимизации над кодом можно произвести для ускорения его выполнения?
К сожалению так глубоко в Ruby не пока копал.. 

Q3: Задача (для меня) достаточно сложная, код пришлю отдельно
