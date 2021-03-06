function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% Add ones to the X data matrix
X = [ones(m, 1) X];

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
a = [ones(m,1) zeros(m,hidden_layer_size)];
aa = [zeros(m,num_labels)];
yVec = repmat([1:num_labels], m, 1) == repmat(y, 1, num_labels);

for t =1 : num_labels
    for i = 1 : hidden_layer_size
        a(:,i+1) = sigmoid(X*Theta1(i,:)');    
    end 
    aa(:,t) = sigmoid (a*Theta2(t,:)');  
end 

thetaShift1 = [zeros(size(Theta1,1),1) Theta1(:,2:end) ];
thetaShift2 = [zeros(size(Theta2,1),1) Theta2(:,2:end) ];

Reg = (lambda/(2*m))* ((sum(sum((thetaShift1).^2)))  + (sum(sum((thetaShift2).^2))));

J = ((1/m)*sum(sum(-yVec .* log(aa) - (1 - yVec) .* log(1 - aa)))) + Reg;


% -------------------------------------------------------------
% Gradients
% =========================================================================

D1 = zeros(size(Theta1));
D2 = zeros(size(Theta2));
for t = 1 : 1
  a1  = X(t,:)';      
  a2 = a(t,:)';    
  a3 = aa(t,:)';
  size(aa)
  a3
  yVec(t,:)'
  d3 = (a3 - yVec(t,:)');
  d3
  z2 = [1; Theta1*a1];
  d2 = Theta2'*d3.*sigmoidGradient(z2);
  
  D1 = D1 + d2(2:end)*(a1)';
  D2 = D2 + d3*(a2)';
  size(D1)
  size(D2)
end 

DReg1 =  (lambda/m)*thetaShift1;
DReg2 =  (lambda/m)*thetaShift2;

Theta1_grad = ((1/m)*(D1)) + DReg1;
Theta2_grad = ((1/m)*(D2)) + DReg2;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
