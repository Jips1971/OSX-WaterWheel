
import SwiftUI
import Combine
import AppKit

struct Drop: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    var life: CGFloat = 20
}

struct ContentView: View {

    @State private var angle: CGFloat = 0
    @State private var drops: [Drop] = []

    private let timer = Timer.publish(
        every: 0.03,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {

        GeometryReader { geo in

            let w = geo.size.width
            let h = geo.size.height

            let cx = w / 2
            let cy = h * 0.55
            let radius = w * 0.36

            ZStack {

                Color(red: 0, green: 0.04, blue: 0.12)
                    .ignoresSafeArea()

                // Water wheel arm
                Canvas { context, size in

                    let x = cx + cos(angle) * radius
                    let y = cy + sin(angle) * radius

                    let tipX = cx + cos(angle) * (radius + 120)
                    let tipY = cy + sin(angle) * (radius + 120)

                    var line = Path()
                    line.move(to: CGPoint(x: x, y: y))
                    line.addLine(to: CGPoint(x: tipX, y: tipY))

                    context.stroke(
                        line,
                        with: .color(Color.gray),
                        style: StrokeStyle(lineWidth: 12)
                    )

                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: x - 14,
                            y: y - 14,
                            width: 28,
                            height: 28
                        )),
                        with: .color(.white)
                    )
                }

                // Water droplets
                Canvas { context, size in

                    for drop in drops {

                        let r = max(1, drop.life)

                        let blue = Color(
                            red: 40 / 255,
                            green: min(255, 120 + drop.life * 6) / 255,
                            blue: 1
                        )

                        let rect = CGRect(
                            x: drop.x - r,
                            y: drop.y - r,
                            width: r * 2,
                            height: r * 2
                        )

                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(blue)
                        )
                    }
                }

                // Title
                VStack {
                    Text("WATER WHEEL")
                        .font(.custom("Impact", size: w * 0.13))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, h * 0.045)

                    Spacer()
                }
            }
            .frame(width: w, height: h)
            .clipped()
            .onReceive(timer) { _ in

                angle += 0.15

                let x = cx + cos(angle) * radius
                let y = cy + sin(angle) * radius

                // Generate droplets
                for _ in 0..<16 {

                    drops.append(
                        Drop(
                            x: x,
                            y: y,
                            vx: CGFloat.random(in: -3...3),
                            vy: CGFloat.random(in: -3...3)
                        )
                    )
                }

                // Update droplets
                for i in drops.indices {

                    drops[i].x += drops[i].vx
                    drops[i].y += drops[i].vy + 0.8
                    drops[i].life -= 0.3
                }

                // Remove expired droplets
                drops.removeAll {
                    $0.life <= 1
                }
            }
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
