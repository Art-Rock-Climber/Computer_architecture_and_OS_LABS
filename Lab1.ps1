param (
    [string]$FolderPath
)

# Проверка на пустую строку
if ([string]::IsNullOrWhiteSpace($FolderPath)) {
    do {
        $FolderPath = Read-Host "Укажите путь к папке с фотографиями"
    } while ([string]::IsNullOrWhiteSpace($FolderPath))
}

# Проверка существования папки
if (-not (Test-Path -Path $FolderPath)) {
    Write-Error "Указанная папка не существует."
    return
}

# Список всех файлов формата JPG в папке, упорядоченный по возрастанию времени создания
$files = Get-ChildItem -Path $FolderPath -Filter *.jpg | Sort-Object -Property CreationTime

# Первый проход: временное переименование файлов
# (Если сразу переименовывать как надо, могут совпасть имена файлов)
for ($i = 1; $i -le $files.Count; $i++) {
    $file = $files[$i - 1]
    Rename-Item -Path $file.FullName -NewName "$i.jpg"
}

# Второй проход: приведение имен к нужному формату
for ($i = 1; $i -le $files.Count; $i++) {
    $oldFileName = "$i.jpg"
    $newFileName = "IMG_{0:D4}.jpg" -f $i
    Rename-Item -Path "$FolderPath\$oldFileName" -NewName $newFileName
}