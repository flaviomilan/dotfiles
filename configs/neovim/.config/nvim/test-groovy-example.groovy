// Test Groovy file to verify LSP configuration

class GroovyExample {
    
    def greet(String name) {
        return "Hello, ${name}!"
    }
    
    def calculateSum(List<Integer> numbers) {
        return numbers.sum()
    }
    
    def processData() {
        def data = [1, 2, 3, 4, 5]
        def result = data.collect { it * 2 }
        println "Original: ${data}"
        println "Doubled: ${result}"
        return result
    }
    
    static void main(String[] args) {
        def example = new GroovyExample()
        
        // Test greeting
        println example.greet("World")
        
        // Test sum calculation
        def numbers = [10, 20, 30, 40]
        println "Sum: ${example.calculateSum(numbers)}"
        
        // Test data processing
        example.processData()
    }
}

// Gradle build script syntax example
task myTask {
    doLast {
        println 'This is a Gradle task'
    }
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    testImplementation 'org.junit.jupiter:junit-jupiter'
}