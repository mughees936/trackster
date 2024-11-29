const StylizeTrackings = {
    mounted() {
        console.log("Hook", this.el);
        let regex = /\[([^\]]+)\]/g;
        let pTags = this.el.querySelectorAll('p');

        console.log(pTags);

        pTags.forEach(p => {
            p.innerHTML = p.innerHTML.replace(regex, '<b class="bg-brand/5 text-brand rounded p-1 font-medium leading-6">$1</b>');
        });
    }
}

export default StylizeTrackings;