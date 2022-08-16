// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


			
				const btn = document.querySelector("button.mobile-menu-button");
				const menu = document.querySelector(".mobile-menu");

				/*btn.addEventListener("click", () => {
					menu.classList.toggle("hidden");
				});
				*/
// below may not be needed Possible remove
				const radioButtons = document.querySelectorAll('input[name="cost"]');

				for (const radioButton of radioButtons) {
					if (radioButton.checked) {
						//the value here is a hash object with many parameters
					  selectedCost = radioButton.value;
					  break;
					}
				}

				
				
				

				
				



				