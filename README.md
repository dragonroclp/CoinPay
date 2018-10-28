# CoinPay
支持多种数字资产即时交易和转换的去中心化闪兑协议
### 项目描述
CoinPay是一个数字货币交易和转换系统，使得用户能快速的将自己手中的某种代币转换为等价的其他代币，并提供能使用户在闪兑过程中获得额外收益的功能。CoinPay解决的主要问题是，用户不需要像在中心化交易所那样充值提现，而直接可以使用去中心化交易平台在不同代币之间进行无缝支付。
### 项目功能
CoinPay主要通过利用自有链的储备库、外接币池两种方式实现闪兑功能。它还提供gamble的特色方式供用户闪兑，允许用户有一定概率获得额外的收益。项目的流程图及主要的三个功能描述如下：
<img align=center width="440" height="440" src='https://github.com/dragonroclp/CoinPay/blob/master/flow%20chart.jpeg'/>
* 1.用自由链的储备库实现闪兑
>>用自有链在其他数字资产链上（如比特币、以太坊等）生成一个地址，用于存放用户想兑换的币种数据。当自有链的储备库拥有*足额的数字货币*、能满足用户需求时，在自有链上用智能合约实现币种之间的兑换。
* 2.采用外接币池方式实现闪兑 
>>当自有链储备库不能满足客户的换币需求时，可以借助其他交易所（中心化或去中心化），*外接币池*，利用其他交易所的数字资产来进行闪兑。
* 3.采用gamble思想实现闪兑
>>除上述两种方式外，用户还可以用gamble这种资产收益不确定的方式来进行兑换，以期获得超额收益。用户输入自己用于支付的币种和数量后，可以选择自己要兑换的币种，平台反馈给用户随机的数量。在这种方式下，用户的*期望收益率为0%。*
##### 在本组设计的去中心化闪兑交易平台上，类的实体包括用户、平台、储存库以及储备贡献者。示意图如下：
<img align=center width="600" height="300" src='https://github.com/dragonroclp/CoinPay/blob/master/class%20diagram.jpg'/>

### 代码实现
#### 网页客户端
- 功能1及功能2（币种直接兑换）页面

>>在这个页面中，用户需要输入自己的姓名、用于兑换的币种和数量，以及想兑换的币种，平台显示实时汇率，若用户决定进行兑换，则平台会记录用户的资产变更。
- 功能3（赌博兑换）页面

>>在这个页面中，用户需要输入自己的姓名以及用于兑换的币种和数量，平台返回用户在此次支付中得到的资产值。
```
import  Nervos from './node_modules/@nervos/chain';
    const nervos =Nervos('http://localhost:1337');
    var sendTo= 0xcB700EE03b47d5fCb389D39B6a76cBC3E1C5ac0f;
const abi=Json.parse([
        {
            "constant": false,
            "inputs": [
                {
                    "name": "_coinName",
                    "type": "string"
                },  //只截取了一部分
const contract=new nervos.appchain.Contract(abi,contractAddress)
    var e1=document.getElementById('have1').value;
    var e2=document.getElementById('number').value;
    
    //const simpleStoreContract = new nervos.appchain.Contract(abi, contractAddress);
    function pay_action() {
contract.methods.gambling(e1,e2).call()
        contract.event.balanceUp()
            .on("data",function(event){
                let data = event.returnValue;
                console.log("success",data._coinName,data._coinValue)
            }).on('error',console.error)
nervos.listeners.listenToTransactionReceipt().then(console.log)
    }
