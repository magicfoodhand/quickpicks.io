
fetch('/api/summary.json')
.then(r => r.json())
.then(response => {
    console.log("Api Data", response)
}).catch(rejected => {
    console.log("Something went wrong", rejected)
})
