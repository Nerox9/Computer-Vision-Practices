deviationX = 0.3;%deviation of X
deviationY = 1;%deviation of Y
%filter sizes
filterX = 15;
filterY = 15;

%+/- filter limits
expandX = filterX/2-0.5;
expandY = filterY/2-0.5;

%defination of gaussian of X 
sigmax = deviationX;%sigma value
mu = 0;
xofX = linspace(-expandX,expandX,100);%x values from -filter limit to +filter limit into 100 pieces
yofX = 1/(sqrt(2*pi)*sigmax)*exp(-(xofX-mu).^2/(2*sigmax^2));%calculation of gaussian distirbution function

%defination of gaussian of Y
sigmay = deviationY;%sigma value
mu = 0;
xofY =  linspace(-expandY,expandY,100);%x values from -filter limit to +filter limit into 100 pieces
yofY =  1/(sqrt(2*pi)*sigmay)*exp(-(xofY-mu).^2/(2*sigmay^2));%calculation of gaussian distirbution function

figure
plot(xofX,yofX)%first Gaussian plotted in blue
hold%plot on same figure
plot(xofY,yofY,'r')%second gaussian plotted in red
plot(xofX,(yofX-yofY),'k')%Differance of Gaussians
legend('Gaussian of X','Gaussian of Y','DoG')

figure%new figure
plot(xofX,(yofX-yofY),'k')%Differance of Gaussians
hold%plot on same figure
fspecial('log',size(xofX),1.1),plot(xofX,-ans);%Laplacian of Gaussian
legend('DoG','LoG')