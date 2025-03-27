# Monitoramento de Servidor Linux na AWS com Discord Webhook

## 📌 Introdução
Este projeto tem como objetivo configurar um ambiente na AWS para hospedar um servidor web e implementar um sistema de monitoramento, enviando notificações para um canal do Discord via Webhook.

---
## 🛠️ 1. Configuração do Ambiente

### 1.1 Criar uma VPC
1. Acesse o [AWS Console](https://aws.amazon.com/console/).
2. Vá até "VPC" e clique em "Create VPC".
3. Escolha um nome para a VPC e configure a faixa de IPs conforme necessário (exemplo: `10.0.0.0/16`).
![1 1](https://github.com/user-attachments/assets/37628480-3869-4f28-ab92-db2f3f41ccbf)



### 1.2 Criar Subnets
1. Dentro da VPC, crie duas subnets:
   - **Pública**: para a instância EC2 acessível via internet.
   - **Privada**: caso precise de instâncias internas sem acesso direto.
![1 2](https://github.com/user-attachments/assets/d1809505-59a4-4a3a-b5d2-feed4cac9fce)

![1 3](https://github.com/user-attachments/assets/61c352ff-74a6-4436-8dfb-229bf16be7f3)

---
## 🏗️ 2. Criando e Configurando o Servidor Web

### 2.1 Criar uma Instância EC2
1. Acesse "EC2" no console da AWS.
2. Clique em "Launch Instance".
3. Escolha a AMI (Ubuntu 22.04 LTS recomendado).
4. Escolha o tipo `t2.micro` (elegível para o Free Tier).
5. Configure a rede usando a VPC e a subnet pública.
6. Associe o Security Group criado anteriormente.
7. Gere ou forneça um par de chaves para acessar via SSH.
![image](https://github.com/user-attachments/assets/88b0173c-4bc0-47ca-a409-6830365ae722)

### 2.2 Conectar na Instância
Após iniciar a instância, conecte-se via SSH:
```sh
ssh -i "seu-arquivo.pem" ubuntu@IP_PUBLICO_DA_INSTANCIA
```

### 2.3 Instalar e Configurar o Nginx
```sh
sudo apt update -y
sudo apt install nginx -y
```

Verifique se o serviço está rodando:
```sh
sudo systemctl status nginx
```

Crie arquivos index.html para cada site:
/var/www/html/index.html
```sh
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SITE 1</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Bem Vindo ao Site 1</h1>
</body>
</html>
```
---
## 📊 3. Criando o Script de Monitoramento

### 3.1 Criar o Script
Crie um arquivo `monitor.sh`:
```sh
nano monitor.sh
```

Adicione o código:
```sh
#!/bin/bash

URL="SEU IP PUBLICO"
WEBHOOK_URL="https://discord.com/api/webhooks/SEU_WEBHOOK_AQUI"
LOG_FILE="/home/ubuntu/meu_script.log"
DATA_HORA=$(date '+%Y-%m-%d %H:%M:%S')

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" -ne 200 ]; then
  echo "$DATA_HORA - Site fora do ar! Código: $STATUS" >> "$LOG_FILE"
  
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \":rotating_light: ALERTA: O site está fora do ar!\"}" \
       "$WEBHOOK_URL"
else
  echo "$DATA_HORA - Site OK (Código: $STATUS)" >> "$LOG_FILE"

fi
```

### 3.2 Tornar o Script Executável
```sh
chmod +x monitor.sh
```

### 3.3 Automatizar com Crontab
Edite o crontab:
```sh
crontab -e
```
Adicione a linha abaixo para rodar a cada minuto:
```sh
* * * * * /home/ubuntu/monitor.sh
```

---
## 🛠️ 4. Testando e Validando a Solução

### 4.1 Teste Manual do Script
1. Pare o serviço Nginx:
   ```sh
   sudo systemctl stop nginx
   ```
2. Execute o script manualmente:
   ```sh
   ./monitor.sh
   ```
3. Verifique se recebeu a notificação no Discord.

### 4.2 Teste Automático via Crontab
1. Reinicie a instância EC2 e veja se o monitoramento continua funcionando.

---
## 🚀 Conclusão
Este projeto mostra como configurar um servidor web na AWS e implementar um sistema de monitoramento automático com notificações no Discord via Webhook. Com isso, é possível acompanhar a disponibilidade do serviço Nginx e agir rapidamente em caso de falhas.
---
✍️ **Autor:** Thiago Salvador Martinez Motroni  
