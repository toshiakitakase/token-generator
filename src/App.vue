<template>
  <div id="app">
    <div class="w-50 mx-auto">
      <h3>オリジナルトークンを作ろう</h3>
      <b-form @submit="onSubmit" @reset="onReset" v-if="show" class="mt-4">
        <b-form-group
          id="input-group-1"
          label="トークン名："
          label-for="input-1"
        >
          <b-form-input 
            id="input-1"
            v-model="form.tokenName"
            type="text"
            required
            placeholder="Bitcoin">
          </b-form-input>
        </b-form-group>
        <b-form-group
          id="input-group-2"
          label="シンボル："
          label-for="input-2"
        >
          <b-form-input 
            id="input-2"
            v-model="form.tokenSymbol"
            type="text"
            required
            placeholder="BTC">
          </b-form-input>
        </b-form-group>
        <b-form-group
          id="input-group-3"
          label="小数点以下の桁数："
          label-for="input-3"
        >
          <b-form-input 
            id="input-3"
            v-model="form.dicimals"
            type="number"
            required
            placeholder="18">
          </b-form-input>
        </b-form-group>
        <b-form-group
          id="input-group-4"
          label="総発行料："
          label-for="input-4"
        >
          <b-form-input 
            id="input-4"
            v-model="form.totalSupply"
            type="number"
            required
            placeholder="1000000000000000000">
          </b-form-input>
        </b-form-group>
        <b-button type="submit" variant="primary" class="mr-2">発行する</b-button>
        <b-button type="reset" variant="danger">リセットする</b-button>
      </b-form>
    </div>
  </div>
</template>
<script>
import Web3 from 'web3'
import TokenGenerator from "../ethereum/build/contracts/TokenGenerator.json"

export default {
  name: 'app',
  data: () => ({
    form: {
      tokenName: '',
      tokenSymbol: '',
      dicimals: 0,
      totalSupply: 0
    },
    show: true
  }),
  components: {
  },
  async created()  {
    if (window.ethereum) {
      web3 = new Web3(ethereum);
      try {
        await ethereum.enable();
      } catch (error) {
        console.log(error)
      }
    }
    else if (web3) {
      web3 = new Web3(web3.currentProvider);
    }
    else {
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
    }
  },
  methods: {
    onSubmit(evt) {
      evt.preventDefault()
      console.log({
        tokenName: this.form.tokenName,
        tokenSymbol: this.form.tokenSymbol,
        dicimals: this.form.dicimals,
        totalSupply: this.form.totalSupply,
        bytecode: TokenGenerator.bytecode,
        abi: TokenGenerator.abi,
        address: web3.currentProvider.selectedAddress
      })
      let contract = new web3.eth.Contract(TokenGenerator.abi)
      contract.deploy({
          data: TokenGenerator.bytecode,
          arguments: [
            this.form.tokenName,
            this.form.tokenSymbol,
            this.form.dicimals,
            this.form.totalSupply
          ]
      })
      .send({
          from: web3.currentProvider.selectedAddress,
          gas:  2000000,
          gasPrice: 20000000000,
      })
      .on('error', (error) => {
          console.log(error)
      })
      .on('transactionHash', (transactionHash) => {
          console.log(transactionHash)
      })
      .on('receipt', async (receipt) => {
          console.log(receipt.contractAddress)
      })
    },
    onReset(evt) {
      evt.preventDefault()
      this.form.tokenName = ''
      this.form.tokenSymbol = ''
      this.form.dicimals = null
      this.form.totalSupply = null
      this.show = false
      this.$nextTick(() => {
        this.show = true
      })
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /* text-align: center; */
  color: #2c3e50;
  margin-top: 60px;
}
</style>
