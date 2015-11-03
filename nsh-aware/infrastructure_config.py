# Config for switches, tunnelIP is the local IP address.
switches = [
            {'name': 'sw1',
             'type': 'hst',
             'dpid': '1'},
            {'name': 'sw2',
             'type': 'sff',
             'dpid': '2'},
            {'name': 'sw3',
             'type': 'pxy',
             'dpid': '3'},
            {'name': 'sw4',
             'type': 'sf',
             'dpid': '4'},
            {'name': 'sw5',
             'type': 'none',
             'dpid': '5'},
            {'name': 'sw6',
             'type': 'none',
             'dpid': '6'},
            {'name': 'sw7',
             'type': 'none',
             'dpid': '7'},
            {'name': 'sw8',
             'type': 'none',
             'dpid': '8'}
	    ]

defaultContainerImage='toshirin/sfcpxy-host'


