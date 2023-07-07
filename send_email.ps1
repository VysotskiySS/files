#Адрес сервера SMTP для отправки
$serverSmtp = "smtp.yandex.ru" 

#Порт сервера
$port = 587

#От кого
$From = "user@mailbox.ru" 

#Кому
$To = "poluchatel@mailbox.ru" 

#Тема письма
$subject = "NIINM-timakova-st-4"

#Логин и пароль от ящика с которого отправляете
$user = "user@mailbox.ru"
$pass = "passwd"

#Создаем архив с файлами
Compress-Archive -Path \\10.0.0.10\Consultant_VR\RECEIVE\*.usr,\\10.0.0.10\Consultant_VR\ADM\STS\*.*,\\10.0.0.10\Consultant_VR\ADM\*.txt -DestinationPath C:\Archive\cons.zip -CompressionLevel Optimal

#Путь до файла 
$file = "C:\Archive\cons.zip"

#Создаем два экземпляра класса
$att = New-object Net.Mail.Attachment($file)
$mes = New-Object System.Net.Mail.MailMessage

#Формируем данные для отправки
$mes.From = $from
$mes.To.Add($to) 
$mes.Subject = $subject 
$mes.IsBodyHTML = $true 
$mes.Body = "<h1>тело письма</h1>"

#Добавляем файл
$mes.Attachments.Add($att) 

#Создаем экземпляр класса подключения к SMTP серверу 
$smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)

#Сервер использует SSL 
$smtp.EnableSSL = $true 

#Создаем экземпляр класса для авторизации на сервере яндекса
$smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);

#Отправляем письмо, освобождаем память
$smtp.Send($mes) 
$att.Dispose()

#Remove-item C:\Archive\cons.zip

#Добавляем текущую дату в имя файла
Get-ChildItem "C:\Archive\cons.zip" | ForEach-Object {          
Rename-Item $_.FullName "$BackupFolder$($_.BaseName -replace " ", "_" -replace '\..*?$')-$(Get-Date -Format "ddMMyyyy").zip"
}

#Удаляем исходные файлы
Remove-item \\10.0.0.10\Consultant_VR\ADM\STS\*.*
