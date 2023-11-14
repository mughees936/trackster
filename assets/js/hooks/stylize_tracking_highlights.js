const StylizeTrackings = {
    mounted() {
        console.log("Hook", this.el);
        let regex = /\[([^\]]+)\]/g;
        let liTags = this.el.querySelectorAll('li');

        console.log(liTags);

        liTags.forEach(td => {
            td.innerHTML = td.innerHTML.replace(regex, '<b class="bg-brand/5 text-brand rounded p-1 font-medium leading-6">$1</b>');
        });
    }
}

export default StylizeTrackings;