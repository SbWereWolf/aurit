# How to install
- Клонировать https://github.com/madorin/fibplus.git
- Запустить RAD Studio XE7
- File/Open
  - В директории репозитория переходим в `\Packages`
выбираем все `*.dproj` файлы с `XE7` в имени
  - "Открыть"
- Project/Compile All Projects
- Project/Build All Projects
- В окне `Project Manager` правой кнопкой мыши по каждому проекту 
и `Install`
- Tools/Options
  - Environment Options/Delphi Options/Library
  - Нажимаем Library path
  - Выбираем директорию клонированного репозитория (fibplus)
  - Add/Ok/Ok
- File/Close All
- File/Open
- Открываем `.\plugins\current_remains_report.dproj`
- Если будут сообщения о том что какие то компоненты не найдены, 
то отвечаем `Cancel`, `Ignore` не нажимать
- Project/Compile All Projects
- Project/Build All Projects
- File/Close All
- Плагин построен (`.\plugins\current_remains_report.dll`)

# How to use
- Запускаем `.\plugin_test.exe`
- В поле `Путь к базе данных` задаём путь к `\db\test_db.FDB`
- Нажимаем `Плагины`
- Выбираем в `Сервис` "наш" плагин и нажимаем `Выполнить`
  - User name - `SYSDBA`
  - Password - `masterkey`
- Плагин запущен
- Выбираем диапазон дат (начальная дата 01.05.2016, 
конечная любая дата после 01.07.2016)
- Нажимаем `Сформировать`
- В строке сосотяния сначала будет написано количество найденных строк
после этого будет написан путь к файлу с данными
- Выгрузка данных выполнена
- Закрываем все окна
- Примечание : программа `plugin_test.exe` 
самостоятельно не выгружается из памяти, 
процес необходимо закрывать в ручную через `Диспетчер задач`

По ТЗ надо было экспортировать данные в XLS, я этот момент упустил и экспорт происходит в XML.
