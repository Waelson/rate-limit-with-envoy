# Rate Limit com Envoy
## Introdução
Essa solução demonstra a utilização de rate limit com Envoy. O rate limit é uma funcionalidade que permite limitar a quantidade de requisições que um serviço pode receber em um determinado período de tempo. O rate limit pode ser aplicado em diferentes níveis, como por exemplo, por serviço, por usuário, por IP, etc.

## Arquitetura
![Architecture](documentation/architecture.png)

#### Componentes da Arquitetura
| **Componente**               | **Descrição**                                                                                                                                                                               |
|-----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Envoy Proxy**              | Intercepta as requisições antes de encaminhá-las para a aplicação. Verifica se a requisição excede os limites definidos.                                                                    |
| **Envoy Rate Limit**         | Serviço responsável por verificar se uma requisição excede o limite permitido, baseado nos dados armazenados no Redis. Se o limite for excedido, retorna erro `HTTP 429 Too Many Requests`. |
| **Redis**                    | Banco de dados utilizado para armazenar informações de Rate Limiting, como contadores de requisições por usuário.                                                                           |
| **StatsD Exporter**          | Converte as métricas enviadas pelo Envoy Rate Limit para o formato compatível com Prometheus.                                                                                               |
| **Prometheus**               | Coleta as métricas do StatsD Exporter a cada 5 segundos e as armazena para análise e monitoramento.                                                                                         |
| **Grafana**                  | Visualiza as métricas coletadas pelo Prometheus e apresenta dashboards para acompanhamento do Rate Limiting.                                                                                |
| **Target Application Cluster** | Conjunto de instâncias da aplicação de destino. Se a requisição estiver dentro do limite, o Envoy Proxy a encaminha para uma dessas instâncias.                                             |

## Configurando e Inicializando a Solução
