json1 = {
    "@context": "https://schema.org/extensions",
    "@type": "MessageCard",
    "username": "MesageBot",
    "themeColor": "#ff0000",
    "title": "Test Message",
    "text": "**Test Message**"
}

json2 = {
    "@context": "https://schema.org/extensions",
    "@type": "MessageCard",
    "username": "MesageBot",
    "themeColor": "#00ff00",
    "title": "Test Message",
    "text": "**Test Message**"
}

json3 = {
    "@context": "https://schema.org/extensions",
    "@type": "MessageCard",
    "username": "MesageBot",
    "themeColor": "#0000ff",
    "title": "Test Message",
    "text": "**Test Message!!** Click buttons below to learn more...",
    "potentialAction": [
        {
            "@type": "OpenUri",
            "name": "Open Wiki",
            "targets": [
                {
                    "os": "default",
                    "uri": "https://wikipedia.org"
                }
            ]
        },
        {
            "@type": "OpenUri",
            "name": "Open Google",
            "targets": [
                {
                    "os": "default",
                    "uri": "https://google.com"
                }
            ]
        }
    ]
}
