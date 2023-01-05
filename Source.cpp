#include <iostream>

using namespace std;

unsigned int calculateDistance(unsigned int point1[], unsigned int point2[]) {

	unsigned int distance = 
		((point1[0] - point2[0]) * (point1[0] - point2[0])) + ((point1[1] - point2[1]) * (point1[1] - point2[1]));
	
	return distance;
}

bool isSquare(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {

	unsigned int distance2 = calculateDistance(point1, point2);
	unsigned int distance3 = calculateDistance(point1, point3);
	unsigned int distance4 = calculateDistance(point1, point4);

	if (distance2 == 0 || distance3 == 0 || distance4 == 0)
		return false;

	if ((distance2 == distance3) && (2 * distance2 == distance4)
		&& (2 * calculateDistance(point2, point4) == calculateDistance(point2, point3)))
		return true;

	if ((distance3 == distance4) && (2 * distance3 == distance2)
		&& (2 * calculateDistance(point3, point2) == calculateDistance(point3, point4)))
		return true;

	if ((distance2 == distance4) && (2 * distance2 == distance3)
		&& (2 * calculateDistance(point2, point3) == calculateDistance(point2, point4)))
		return true;

	return false;
}

bool isRectangle(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {

	unsigned int distanceWidth1 = calculateDistance(point1, point2);
	unsigned int distanceWidth2 = calculateDistance(point3, point4);

	unsigned int distanceHeight1 = calculateDistance(point1, point4);
	unsigned int distanceHeight2 = calculateDistance(point2, point3);

	unsigned int distanceDiagonal1 = calculateDistance(point1, point3);
	unsigned int distanceDiagonal2 = calculateDistance(point2, point4);

	if (distanceHeight1 == distanceHeight2
		&& distanceWidth1 == distanceWidth2
		&& distanceDiagonal1 == distanceDiagonal2
		&& distanceHeight1 != distanceWidth1)
		return true;

	return false;
}

bool isTriangle(unsigned int point1[], unsigned int point2[], unsigned int point3[]) {
	int area = point1[0] * (point2[1] - point3[1]) +
		point2[1] * (point3[1]) - (point1[1]) +
		point3[1] * (point1[1]) - (point2[1]);

	if (area == 0)
		return false;
	else
		return true;
}

void drawSquare(unsigned int point1[], unsigned int point2[]) {

	double size = round(sqrt(calculateDistance(point1, point2)));

	for (int i = 0; i < size; i++) {

		for (int j = 0; j < size; j++) {
			if (i == 0 || i == size - 1 || j == 0 || j == size - 1) {
				cout << "* ";
			}
			else
				cout << "  ";
		}
		cout << endl;
	}
}

void drawRectangle(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {

	double distanceWidth = round(sqrt(calculateDistance(point1, point2)));
	double distanceHeight = round(sqrt(calculateDistance(point1, point4)));

	for (int i = 0; i < distanceWidth; i++) {

		for (int j = 0; j < distanceHeight; j++) {
			if (i == 0 || i == distanceWidth - 1 || j == 0 || j == distanceHeight - 1) {
				cout << "* ";
			}
			else
				cout << "  ";
		}
		cout << endl;
	}
}

void drawTriangle(unsigned int point1[], unsigned int point2[], unsigned int point3[]) {
	double distanceWidth = round(sqrt(calculateDistance(point1, point2)));
	double distancelHeight = round(sqrt(calculateDistance(point2, point3)));
	double distancerHeight = round(sqrt(calculateDistance(point1, point3)));

	for (int i = 1; i <= distancelHeight; i++) {
		for (int space = i; space < distancelHeight; space++)
			cout << "  ";

		for (int j = 1; j <= (2 * distancelHeight - 1); j++) {
			if (i == distancelHeight || j == 1 || j == 2 * i - 1)
				cout << "*";
			else
				cout << " ";
		}
		cout << "\n";
	}
}

void printFourPoints(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {

	for (int i = 0; i < 1; i++) {
		cout << "(" << point1[i] << ", " << point1[i + 1] << ")" << endl;
		cout << "(" << point2[i] << ", " << point2[i + 1] << ")" << endl;
		cout << "(" << point3[i] << ", " << point3[i + 1] << ")" << endl;
		cout << "(" << point4[i] << ", " << point4[i + 1] << ")" << endl;
	}
	cout << endl;
}

void printThreePoints(unsigned int point1[], unsigned int point2[], unsigned int point3[]) {

	for (int i = 0; i < 1; i++) {
		cout << "(" << point1[i] << ", " << point1[i + 1] << ")" << endl;
		cout << "(" << point2[i] << ", " << point2[i + 1] << ")" << endl;
		cout << "(" << point3[i] << ", " << point3[i + 1] << ")" << endl;
	}
	cout << endl;
}

void getFourPoints(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {
	
	cout << "Enter the points: \n";
	cin >> point1[0] >> point1[1];
	cin >> point2[0] >> point2[1];
	cin >> point3[0] >> point3[1];
	cin >> point4[0] >> point4[1];
}

void getThreePoints(unsigned int point1[], unsigned int point2[], unsigned int point3[]) {

	cout << "Enter the points: \n";
	cin >> point1[0] >> point1[1];
	cin >> point2[0] >> point2[1];
	cin >> point3[0] >> point3[1];
}

void doFourPoints(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {

	cout << endl;
	printFourPoints(point1, point2, point3, point4);

	if (isSquare(point1, point2, point3, point4)) {
		cout << "Square! \n\n";
		drawSquare(point1, point2);
	}
	else if (isRectangle(point1, point2, point3, point4)) {
		cout << "Rectangle! \n\n";
		drawRectangle(point1, point2, point3, point4);
	}
	else
		cout << "UnKnown! \n";
}

void doThreePoints(unsigned int point1[], unsigned int point2[], unsigned int point3[]) {

	cout << endl;
	printThreePoints(point1, point2, point3);

	if (isTriangle(point1, point2, point3)) {
		cout << "Triangle! \n\n";
		drawTriangle(point1, point2, point3);
	}
	else
		cout << "UnKnown! \n";
}

void Menu(unsigned int point1[], unsigned int point2[], unsigned int point3[], unsigned int point4[]) {
	int option = 0;
	
	cout << "Do you want enter 4 points (option 1) or 3 points (option 2)? \n";
	cout << "Choose your option: ";
	cin >> option;

	if (option == 1) {
		getFourPoints(point1, point2, point3, point4);
		doFourPoints(point1, point2, point3, point4);
	}
	else {
		getThreePoints(point1, point2, point3);
		doThreePoints(point1, point2, point3);
	}
}

int main() {

	//Test Square
	/*unsigned int point1[2] = { 20, 10 },
		point2[2] = { 10, 20 },
		point3[2] = { 20, 20 },
		point4[2] = { 10, 10 };*/
	
	//Test2 Square
	/*unsigned int point1[2] = { 1, 1 },
		point2[2] = { 3, 1 },
		point3[2] = { 3, 3 },
		point4[2] = { 1, 3 };*/

	//Test Rectangle
	/*unsigned int point1[2] = {0, 0},
		point2[2] = { 6, 0 },
		point3[2] = { 6, 5 },
		point4[2] = { 0, 5 };*/

	//Test2 Rectangle
	/*unsigned int point1[2] = { 4, 2 },
		point2[2] = { 2, 8 },
		point3[2] = { 14, 12 },
		point4[2] = { 16, 6 };*/

	//Test 1 Traiangle
	/*unsigned int point1[2] = { 1, 4 },
		point2[2] = { 2, 7 },
		point3[2] = { 1, 12 };*/

	//Test 1 Rhombic
	/*unsigned int point1[2] = { 2, 2 },
		point2[2] = { 12 2 },
		point3[2] = { 18, 10 },
		point4[2] = { 8, 10 };*/

	unsigned int point1[2],
		point2[2],
		point3[2],
		point4[2];

	Menu(point1, point2, point3, point4);

	return 0;
}