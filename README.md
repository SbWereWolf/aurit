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
- Открываем \plugins\techsupport.dproj
- Если будут сообщения о том что какие то компоненты не найдены, 
то отвечаем `Cancel`, `Ignore` не нажимать
- Project/Compile All Projects
- Project/Build All Projects
- File/Close All
- Запускаем `plugin_test.exe`
- В поле `Путь к базе данных` задаём путь к `\db\test_db.FDB`
- Нажимаем `Плагины`
- Выбираем в `Сервис` плагин и нажимаем `Выполнить`
  - User name - SYSDBA
  - Password - masterkey
  - Role - SYSDBA
- Плагин запущен
- Примечание : программа `plugin_test.exe` 
самостоятельно не выгружается из памяти, 
процес необходимо закрывать в ручную через `Диспетчер задач`
