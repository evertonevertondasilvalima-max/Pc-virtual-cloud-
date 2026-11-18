# VirtualPC Cloud — Windows remoto pelo navegador

Este repositório contém o portal web e o gateway Apache Guacamole para acessar uma **VM Windows real** pelo navegador do celular.

> Importante: GitHub Pages não executa Windows nem hospeda máquinas virtuais. Este projeto prepara o gateway. É necessário contratar/configurar um servidor Linux para o gateway e uma VM Windows separada. Serviços de nuvem podem gerar cobranças; peça a um responsável para revisar e aprovar qualquer gasto.

## Arquitetura
- Portal HTTPS servido pelo Nginx.
- Apache Guacamole + guacd para sessão RDP HTML5 no navegador.
- PostgreSQL para autenticação/configuração do Guacamole.
- VM Windows 11 separada, acessada pelo IP privado através de RDP.

## Limitações
- O projeto não inclui créditos, licença Windows, VM ligada ou GPU.
- RDP/Guacamole é destinado principalmente a desktop e produtividade; não garante baixa latência, 60 FPS ou compatibilidade total com controles de jogos.
- Uma GPU NVIDIA A10 em nuvem não é uma RTX 3060.
- Não exponha TCP 3389 (RDP) à Internet. Permita apenas o acesso privado do gateway.

## Requisitos do gateway
- VM Linux x86-64 com Docker Engine e Docker Compose plugin.
- Domínio/subdomínio com DNS apontado para o IP público do gateway.
- TCP 80 e 443 liberados para o gateway.
- Rede privada entre gateway e VM Windows.

## Instalação
1. Aponte o DNS do domínio para o IP público do gateway.
2. Copie este repositório para a VM Linux.
3. Execute:
   `chmod +x scripts/setup.sh && sudo ./scripts/setup.sh`
4. Acesse `https://SEU_DOMINIO/guacamole/`.
5. No primeiro acesso, use `guacadmin / guacadmin` e troque a senha imediatamente.

O script cria um arquivo `.env` com senha aleatória do banco. Nunca envie esse arquivo ao GitHub.

## Conectar o Windows
No painel Guacamole, crie uma conexão:
- Protocol: RDP
- Hostname: IP privado da VM Windows
- Port: 3389
- Username/password: credenciais de uma conta Windows autorizada
- Security: NLA, quando disponível

Na rede da VM Windows, libere TCP 3389 **somente** a partir do gateway privado. Nunca crie uma regra pública para RDP.

## Preparar Windows
Execute `windows/enable-rdp.ps1` como Administrador na VM Windows. Depois verifique as regras de firewall e restrinja o acesso na rede cloud ao gateway.

## Referências
- Apache Guacamole: https://guacamole.apache.org/
- Manual: https://guacamole.apache.org/doc/gug/
- Azure NVadsA10_v5: https://learn.microsoft.com/azure/virtual-machines/sizes/gpu-accelerated/nvadsa10v5-series
- Drivers NVIDIA em VMs Azure: https://learn.microsoft.com/azure/virtual-machines/windows/n-series-driver-setup
