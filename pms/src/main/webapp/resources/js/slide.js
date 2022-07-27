 const interval = 3000;
 
 const projectContainer = document.querySelector('.frame'); 
 const projects = document.querySelector('.myProjects');
 
 const prevBtn = document.getElementById('prev');
 const nextBtn = document.getElementById('next');
 
 let slides = document.querySelectorAll('.slide');
 let slideIndex = 0;
 slides[slideIndex+1].className = 'slide now';
 let lastSlideIndex = slideIndex - 1;
 let slideId;
 const slideWidth = slides[slideIndex].clientWidth;

 projects.style.transform = 'translateX(' + (-slideWidth * slideIndex) + 'px)';

const startSlide = (isFirst) => {
	slideId = setInterval(() => {
		moveToNextSlide();
	}, interval);
	
}

let getSlides = () => document.querySelectorAll('.slide');
const moveToNextSlide = () => {
	slides = getSlides();
	
	if(slideIndex == 0) {
		lastSlideIndex = slideIndex;
		slideIndex++;
	}else if(slideIndex == slides.length - 1) {
		lastSlideIndex = slideIndex;
		slideIndex--;
		
	}else if(lastSlideIndex < slideIndex){
		lastSlideIndex = slideIndex;
		slideIndex++;
	}else{
		lastSlideIndex = slideIndex;
		slideIndex--;
	}
	
	for(idx = 0; idx < slides.length; idx++){
		slides[idx].className = (idx == slideIndex+1 && slideIndex != slides.length-1)? "slide now":"slide";
		slides[idx].style.transition = '.8s all ease-in-out';
	}
	
	projects.style.transform = 'translateX(' + (-slideWidth * slideIndex) + 'px)';
	projects.style.transition = 'all 1.5s ease-in-out';
}


projectContainer.addEventListener('mouseover', ()=>{
	clearInterval(slideId);
});
projectContainer.addEventListener('mouseleave', startSlide);

nextBtn.addEventListener('click', function(){
	moveToNextSlide();
});
prevBtn.addEventListener('click', function(){
	moveToNextSlide();
});

startSlide(true);