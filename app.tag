<search>
    <div>
        <input type="text" class="form-control" placeholder="Enter License Number" id="license" />
        <input type="button" class="form-control" onclick={getResults} Value="Search" />
        <hr>
        <h3 if={this.displayresults.length === 0 && this.license.value.length > 0}>No results found!</h3>
        <table if={this.displayresults.length > 0 || this.license.value.length > 0}>
            <tr>
                <th></th>
                <th></th>
                <th>License Number</th>
                <th>Name</th>
                <th>Type</th>
                <th>Details</th>
                <th>Date</th>
                <th></th>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td><input type="text" class="form-control" id="newlicense" value={this.license.value} /></td>
                <td><input type="text" class="form-control" placeholder="Name" id="name" value={this.displayresults[0].name}/></td>
                <td><input type="text" class="form-control" placeholder="Type" id="type" /></td>
                <td><input type="text" class="form-control" placeholder="Details" id="details" /></td>
                <td><input type="text" class="form-control" id="date" value={today} /></td>
                <td><i class="fa fa-plus" onclick={add}></i></td>
            </tr>
            <tr each={display, d in this.displayresults}>
                <td><i class="fa fa-times" onclick={parent.remove}></i></td>
                <td><i class="fa fa-pencil" onclick={parent.edit} if={!display.edit}></i></td>
                <td if={!display.edit}>{display.displaylicense}</td>
                <td if={display.edit}><input type="text" class="form-control" name="displaylicense" /></td>
                <td if={!display.edit}>{display.displayname}</td>
                <td if={display.edit}><input type="text" class="form-control" name="displayname" /></td>
                <td if={!display.edit}>{display.displaytype}</td>
                <td if={display.edit}><input type="text" class="form-control" name="displaytype" /></td>
                <td if={!display.edit}>{display.displaydetails}</td>
                <td if={display.edit}><input type="text" class="form-control" name="displaydetails" /></td>
                <td if={!display.edit}>{display.displaydate}</td>
                <td if={display.edit}><input type="text" class="form-control" name="displaydate" /></td>
                <td><i class="fa fa-save" if={display.edit} onclick={parent.save}></td>
            </tr>
        </table>

    </div>

    <script>
        this.objToday = new Date(),
            weekday = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
            dayOfWeek = weekday[this.objToday.getDay()],
            domEnder = new Array( 'th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th' ),
            dayOfMonth = this.today + (this.objToday.getDate() < 10) ? '0' + this.objToday.getDate() : this.objToday.getDate(),
            months = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
            curMonth = months[this.objToday.getMonth()],
            curYear = this.objToday.getFullYear(),
            curHour = this.objToday.getHours() > 12 ? this.objToday.getHours() - 12 : (this.objToday.getHours() < 10 ? "0" + this.objToday.getHours() : this.objToday.getHours()),
            curMinute = this.objToday.getMinutes() < 10 ? "0" + this.objToday.getMinutes() : this.objToday.getMinutes(),
            curSeconds = this.objToday.getSeconds() < 10 ? "0" + this.objToday.getSeconds() : this.objToday.getSeconds(),
            curMeridiem = this.objToday.getHours() > 12 ? "PM" : "AM";

        this.today = this.objToday.getMonth() + "/" + dayOfMonth + "/" + curYear;

        if(localStorage.results === undefined){
            localStorage.results = [];
        }

        this.results = [];
        this.displayresults = [];
        var self = this;

        add(){
            var newlicense = this.newlicense.value;
            var entry = {
                displaylicense:newlicense,
                displayname:this.name.value,
                displaytype:this.type.value,
                displaydetails:this.details.value,
                displaydate:this.date.value,
                id:newlicense+this.displayresults.length,
                edit:false};

            clearForm();

            this.displayresults.push(entry);
            this.results.push(entry);
            localStorage.results = JSON.stringify(this.results.sort(function(a, b){return a.id-b.id}));
            riot.update();
        }
        function clearForm(){
            this.name.value = '';
            this.type.value = '';
            this.details.value = '';
        }
        edit(e){
            var item = e.item;
            var index = getIndexFromDisplayResults(item);
            this.displayresults[index].edit = true;
        }
        remove(e){
            var item = e.item;
            var index = getIndexFromDisplayResults(item);
            this.displayresults.splice(index, 1);
            index = getIndexFromResults(item);
            this.results.splice(index, 1);
            localStorage.results = JSON.stringify(this.results.sort(function(a, b){return a.id-b.id}));
            riot.update();
        }
        trythis(e){
            console.log(this.displaylicense.value);
        }
        save(e){
            console.log(this.displayresults);
            var item = e.item;
            var updated_item = {
                displaylicense:this.displaylicense.value,
                displayname:this.displayname.value,
                displaytype:this.displaytype.value,
                displaydetails:this.displaydetails.value,
                displaydate:this.displaydate.value,
                id:item.id,
                edit:false};

            var index = getIndexFromDisplayResults(item);
            this.displayresults[index] = updated_item;
            index = getIndexFromResults(item);
            this.results[index] = updated_item;
            localStorage.results = JSON.stringify(this.results.sort(function(a, b){return a.id-b.id}));
        }
        function getIndexFromDisplayResults(item){
            var count = 0;
            while(count < self.displayresults.length){
                if(item.display.id === self.displayresults[count].id){
                    return count;
                }
                count += 1
            }
        }
        function getIndexFromResults(item){
            var count = 0;
            while(count < self.results.length){
                if(item.display.id === self.results[count].id){
                    return count;
                }
            count += 1
            }
        }
        getResults(){
            if(localStorage.results === '' || localStorage.results === undefined){
                this.emptymessage = "No results found.";
            }
            else{
                this.displayresults = [];
                this.results = JSON.parse(localStorage.results);
                var count = 0;
                while(count < this.results.length){
                    if(this.results[count].displaylicense === this.license.value){
                        this.displayresults.push(this.results[count]);
                    }
                    count += 1;
                }
            }
        }

    </script>
</search>


