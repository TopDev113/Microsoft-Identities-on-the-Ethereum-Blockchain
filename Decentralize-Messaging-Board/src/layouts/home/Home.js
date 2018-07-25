import React, { Component } from 'react'
import { AccountData, ContractData, ContractForm } from 'drizzle-react-components'
import logo from '../../logo.png'
import PropTypes from 'prop-types'


var totalPosts = 0;
class Home extends Component {

  constructor(props, context) {
    super(props)
    this.contracts = context.drizzle.contracts;
  }

  createPostTable = () => {
    let table = []

    // Outer loop to create parent
    for (let i = 1; i < totalPosts; i++) {
      //Create the parent and add the children
      table.push(
        <div style={{"backgroundColor":"lightblue"}}>
        <h2>Author Affiliation: </h2>
        <ContractData contract="DMB" method="getPostAuthorAffiliation" methodArgs={[i]}/>
        <h2>Author TenantId: </h2>
        <ContractData contract="DMB" method="getTokenTenantId" methodArgs={[i]}/>
        <h2>Author Address: </h2>
        <ContractData contract="DMB" method="ownerOf" methodArgs={[i]}/>
        <h2>Content: </h2>
        <p>
        <ContractData contract="DMB" method="tokenURI" methodArgs={[i]}/>
        </p>
        <br/><br/>
        </div>
      );
    }
    return table
  }

  render() {
    //Get total number of the posts

    this.contracts.DMB.methods.erc721TokenId().call().then(function(num){
        totalPosts = num;
    });
  
    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1 header">
            <img src={logo} alt="drizzle-logo" />
            <h1>Drizzle Examples</h1>
            <p>Examples of how to get started with Drizzle in various situations.</p>

            <br/><br/>
          </div>
        
          <div className="pure-u-1-1">
            <h2>Active Account</h2>
            <AccountData accountIndex="0" units="ether" precision="3" />

            <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>Decentralize Messaging Board Demo</h2>
            <p>Hack way to create tenantId</p>
            <ContractForm contract="DMB" method="setTenantId" />
            <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>Decentralize Messaging Board Demo</h2>
            <p>Simple way to post a new post</p>
            <ContractForm contract="DMB" method="createNewPost" />
            <br/><br/>
          </div>
          <div className="pure-u-1-1">
            {
              this.createPostTable()
            }
            <br/><br/>
          </div>
           {/* <div className="pure-u-1-1">
            <h2>Decentralize Messaging Board Demo</h2>
            <p>Simple way to view all the posts</p>

            <ContractForm contract="DMB" method="set" />
            <br/><br/> 
          </div>*/}

          {/* <div className="pure-u-1-1">
            <h2>TutorialToken</h2>
            <p>Here we have a form with custom, friendly labels. Also note the token symbol will not display a loading indicator. We've suppressed it with the <code>hideIndicator</code> prop because we know this variable is constant.</p>
            <p><strong>Total Supply</strong>: <ContractData contract="TutorialToken" method="totalSupply" methodArgs={[{from: this.props.accounts[0]}]} /> <ContractData contract="TutorialToken" method="symbol" hideIndicator /></p>
            <p><strong>My Balance</strong>: <ContractData contract="TutorialToken" method="balanceOf" methodArgs={[this.props.accounts[0]]} /></p>
            <h3>Send Tokens</h3>
            <ContractForm contract="TutorialToken" method="transfer" labels={['To Address', 'Amount to Send']} />

            <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>ComplexStorage</h2>
            <p>Finally this contract shows data types with additional considerations. Note in the code the strings below are converted from bytes to UTF-8 strings and the device data struct is iterated as a list.</p>
            <p><strong>String 1</strong>: <ContractData contract="ComplexStorage" method="string1" toUtf8 /></p>
            <p><strong>String 2</strong>: <ContractData contract="ComplexStorage" method="string2" toUtf8 /></p>
            <strong>Single Device Data</strong>: <ContractData contract="ComplexStorage" method="singleDD" />

            <br/><br/>
          </div> */}
        </div>
      </main>
    )
  }
}

Home.contextTypes = {
  drizzle: PropTypes.object
}

export default Home
