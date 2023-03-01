param( [String]$t = "t", [String]$a = "a")

#$t = $t -split","


$P = Import-Csv -Path $a -Delimiter ','

#Contar vulnerabilidades totais

$vulHigh =   $P | Select-Object 'Result Severity' | Where-Object {$_.'Result Severity' -eq 'High'}   | Measure
$vulMedium = $P | Select-Object 'Result Severity' | Where-Object {$_.'Result Severity' -eq 'Medium'} | Measure
$vulLow =    $P | Select-Object 'Result Severity' | Where-Object {$_.'Result Severity' -eq 'Low'}    | Measure

#Contar vulnerabilidades novas

$vulNewHigh =   $P | Select-Object -Property 'Result Status', 'Result Severity' | Where-Object {($_.'Result Status' -eq 'New') -and ($_.'Result Severity' -eq 'High')}   | Measure
$vulNewMedium = $P | Select-Object -Property 'Result Status', 'Result Severity' | Where-Object {($_.'Result Status' -eq 'New') -and ($_.'Result Severity' -eq 'Medium')} | Measure
$vulNewLow =    $P | Select-Object -Property 'Result Status', 'Result Severity' | Where-Object {($_.'Result Status' -eq 'New') -and ($_.'Result Severity' -eq 'Low')}    | Measure

#Informações do projeto

$ProjectLink = ($P | Select-Object -Property 'Link')
$ProjectName = $a.Substring(0,$a.IndexOf(".csv"))

$Link = $ProjectLink[0]
$Link = $Link -replace '@{Link=',''
$Link = $Link -replace '}',''

$posicao = $Link.Indexof("?scanid")
$LinkOk = $Link.substring(0,$posicao)


#Executa para vulnerabilidades Altas ou Médias maiores que 0:

if ( ($vulHigh.Count+$vulMedium.Count) -gt 0 )
{

   #Dados Email

   $Subject = 'Checkmarx Warning! Projeto [' + $ProjectName + '] com vulnerabilidades!'

   $vulHighTotal = $vulHigh.Count
   $vulMediumTotal = $vulMedium.Count
   $vulLowTotal = $vulLow.Count
   $vulTotal = $vulHighTotal + $vulMediumTotal + $vulLowTotal
   
   $vulNewHighTotal = $vulNewHigh.Count
   $vulNewMediumTotal = $vulNewMedium.Count
   $vulNewLowTotal = $vulNewLow.Count
   $vulNovasTotal = $vulNewHighTotal + $vulNewMediumTotal + $vulNewLowTotal
   
   $Body += "<style>

        table {
		    border: 1px solid #fff;
		    border-collapse: collapse;
		    padding: 5px;
            text-align: center;
        }

        th, td {
            border: 1px solid #C0C0C0;
		    padding: 5px;
        }

        th {
            width: 65px;
            background:#e3e3e3;
        }
		
		#vazio {
			border: none;
			background: transparent;
		}
    </style>
	<b>Projeto:</b> $ProjectName
	<br> <br>
    <table>
        <tr>
            <th id='vazio'></th>
            <th>High</th>
            <th>Medium</th>
            <th>Low</th>
            <th>Total</th>
        </tr>
        <tr>
            <td>Totais</td>
            <td>$vulHighTotal</td>
            <td>$vulMediumTotal</td>
            <td>$vulLowTotal</td>
            <td>$vulTotal</td>
        </tr>
        <tr>
            <td>Novas</td>
            <td>$vulNewHighTotal</td>
            <td>$vulNewMediumTotal</td>
            <td>$vulNewLowTotal</td>
            <td>$vulNovasTotal</td>
        </tr>
    </table>
	<br><br>
	<p>
	<a href=$LinkOk>Clique aqui para visualizar os resultados</a>
	</p>
	<p>&nbsp;</p>
	<p>*Este &eacute; um e-mail autom&aacute;tico, por favor, n&atilde;o responda.</p>
	<br><br>"


$Username = "dimitriusp@gmail.com";
$Password = "wdcxviswzmhlngrq";

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "dimitriusp@gmail.com";
    $message.To.Add($email);
    $message.Subject = $Subject;
    $message.Body = $Body;
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

}
