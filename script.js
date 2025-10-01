// Mobile menu toggle
const menuToggle = document.getElementById('menuToggle');
const nav = document.getElementById('nav');
menuToggle?.addEventListener('click', ()=>{
  if(!nav) return;
  const isOpen = nav.style.display === 'flex' || getComputedStyle(nav).display === 'flex';
  nav.style.display = isOpen ? 'none' : 'flex';
});

// contact form demo handler
const form = document.getElementById('contactForm');
if(form){
  form.addEventListener('submit', async (e)=>{
    e.preventDefault();
    const endpoint = form.getAttribute('data-endpoint')?.trim();
    if(!endpoint){
      alert('No form endpoint configured. See README for Formspree instructions.');
      return;
    }

    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn?.textContent;
    try{
      if(submitBtn) submitBtn.textContent = 'Sending...';
      const formData = new FormData(form);
      // Formspree expects either JSON or form-encoded POST to the form endpoint
      const resp = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Accept': 'application/json'
        },
        body: formData
      });

      if(resp.ok){
        alert('Thanks — your message was sent.');
        form.reset();
      } else {
        const data = await resp.json().catch(()=>({}));
        const msg = data.error || 'There was an error sending your message.';
        alert(msg);
      }
    }catch(err){
      console.error('Form submit error', err);
      alert('Network error. Please try again later.');
    }finally{
      if(submitBtn) submitBtn.textContent = originalText;
    }
  });
}
    function checkScreenSize() {
        if (window.innerWidth < 768) {
            // Apply specific JavaScript logic for mobile
            console.log("Mobile view detected");
            // Example: Change a class or modify DOM elements
            document.body.classList.add('mobile-layout');
        } else {
            // Apply specific JavaScript logic for desktop
            console.log("Desktop view detected");
            document.body.classList.add('mobile-layout');
        }
    }

    // Run on page load and window resize
    window.addEventListener('load', checkScreenSize);
    window.addEventListener('resize', checkScreenSize);

      function redirectToBandcamp() {
        window.open("https://horizonsofavarice.bandcamp.com");
    }

    function redirectToGoFundMe() {
      window.open("https://gofund.me/b5b130d5d");
  }

  // Create the new image element
const newImage = document.createElement('img');

// Set the source and alt text
newImage.src = 'HeroBL.jpeg';
newImage.alt = 'Band Logo';

// Get a reference to an existing container in the HTML
const container = document.getElementById('image-container');

// Append the new image to the container
container.appendChild(newImage);

