import React from 'react';
import UdDashboard from './ud-dashboard.jsx'
import {
    BrowserRouter as Router,
    Route
} from 'react-router-dom'
import {getApiPath} from 'config';
import Spinner from 'react-spinkit';

export default class App extends React.Component {

    constructor() {
        super();

        this.state = {
            loading: true
        }
    }

    loadJavascript(url, onLoad) {
        var jsElm = document.createElement("script");
        jsElm.onload = onLoad;
        jsElm.type = "application/javascript";
        jsElm.src = url;
        document.body.appendChild(jsElm);
    }

    componentWillMount() {
        this.loadJavascript(getApiPath() + "/api/internal/javascript/framework", function() {
            this.setState({
                loading: false
            })
        }.bind(this))
    }

    render () {
        var regex = new RegExp('^' + window.baseUrl + '(?!.*(\/login))(?!.*(\/license)).*$');

        if (this.state.loading) {
            return <div style={{backgroundColor: '#FFFFFF'}} className="v-wrap">
                        <article className="v-box">
                            <Spinner name="folding-cube" style={{width: '150px', height: '150px', color: '#0689B7'}}/>
                        </article>
                        
                    </div>
        }

        return (<Router>
                <div className="ud-dashboard">
                    <Route path={regex} component={UdDashboard} />
                </div>
            </Router> )
  }
}
