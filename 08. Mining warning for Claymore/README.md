Project Name: 礦機偵測器 for Claymore
==============

Installation and Usage
=============

本工具的原理為：會先找尋 Claymore 最新的 *log.txt 檔，並將它複製到 _temp.txt 內，以避免影響 Claymore 的紀錄功能。
接著會抓取「GPU0」、「Total Speed」等關鍵字，並將「Total Speed」後的總算力值與使用者所輸入的最低算力門檻值進行比較。
只要算力一低於門檻值，就會發信到指定信箱內。

### 1. 請將 _warnMail.vbs 置於和 Claymore 主程式同一個資料夾內。

### 2. 需先開通信箱支援 IMAP，這邊首推使用 Gmail。

### 3. 使用記事本開啟 _warnMail.vbs 程式，並修改「使用者定義區」。

### 4. 請為自己設置合適的整體算力「totalSpeed」若低於此值，則發信告警。

### 5、要注意「收件人」必須是支援 IMAP 的信箱，第一次執行 _warnMail.vbs 時，會要求填入信箱的帳號及密碼，並將之編碼儲存至 _mail_password.xml 內，要注意的是，不同電腦的編碼方式不一樣，更換電腦後，請重新製作 _mail_password.xml 檔，否則會出錯。

### 6、透過 scanFrequency 參數可設定掃描時間，因為複製 *log.txt 檔到 _temp.txt 時會消耗 CPU，故建議不要低於 5 分鐘。

### 7、設置完畢後，在執行之前，請確定 Claymore 已正在執行，並建立 *.log.txt 檔；接著只要點選 _warnMail.vbs 二下即開始運作。

### 8、若想關閉程式，請在 Windows 下方「工作列」上按【右鍵】→【工作管理員】，找到一隻名為【Micorsoft R Windows Based Script Host】的程序，【結束工作】即可。

License
=============

opyright {yyyy} Sean Chen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.