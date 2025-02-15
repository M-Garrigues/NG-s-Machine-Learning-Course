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
         

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

X = [ones(m, 1) X];% we add the 1 column to take the bias into account

row = [ones(m, 1) sigmoid((X * Theta1'))]; %calculates the hidden layer through feed forward, adds the 1 column

H = sigmoid(row * Theta2'); %output layer


for i = 1:num_labels
    K(i) = -(y==i)' * log(H(:,i)) - (1 - (y==i))' * log(1 - H(:,i));
end

J = (sum(K)/m) + (lambda/(2*m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)))  ; %last part is regularisation, not on the biases weights though

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


Y = (y==1);

for i = 2:num_labels
    Y = [Y (y==i)];
end

D2 = zeros(size(row(1,:)));
D1 = zeros(size(X(1,:)));



for t = 1:m
    
    %step 1
    
    a1 = X(t,:);       
    z2 = a1 * Theta1';
    a2 = [1 sigmoid(z2)];
    z3 = a2 * Theta2';
    a3 = sigmoid(z3);
    
    %step 2
    
    d3 = (a3 - Y(t,:));
    %step 3
        
    d2 = (d3 * Theta2(:,2:end) .* sigmoidGradient(z2)); 

    %we skip the weights of the bias, ase they're not related to 1st layer activation error.
    
    
    %step 4
    
    D2 = D2 + d3'*a2;
    D1 = D1 + d2'*a1;
    

end

Theta1_grad = D1./m;
Theta2_grad = D2./m;

reg1 = (lambda/m) * Theta1(:,2:end);
reg2 = (lambda/m) * Theta2(:,2:end);

Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + reg1;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + reg2;


% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
