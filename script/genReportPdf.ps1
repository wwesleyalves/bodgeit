param( [String]$t = "t", [String]$a = "a")




$Username = "dimitriusp@gmail.com";
$Password = "wdcxviswzmhlngrq";

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "dimitriusp@gmail.com";
    $message.To.Add($email);
    $message.Subject = $Subject;
    $message.IsBodyHtml = $true;
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }

Send-ToEmail  -email $t -attachmentpath $a;
