//  File for the CoffeeDrop Constants such as the Supabase API Client and Stripe Client
//
//  Created by Temurbek Sayfutdinov on 2/1/25.
//

import Supabase
import Foundation
struct Constants{
    struct API  {
        static let supabaseClient = SupabaseClient(supabaseURL: URL(string: ProcessInfo.processInfo.environment["SUPABASE_URL"]!)!  , supabaseKey: ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]! )
    }
}
