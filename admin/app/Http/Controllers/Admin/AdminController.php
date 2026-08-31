<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PaymentOrder;
use App\Models\ProductOrder;
use App\Models\SavedCard;
use App\Models\User;
use App\Support\StaticAdminData;
use Illuminate\Contracts\View\View;

class AdminController extends Controller
{
    public function dashboard(): View
    {
        $totalUsers = User::count();
        $successfulOrders = ProductOrder::whereIn('status', ['paid', 'delivered'])->count();

        // Leads: Users who haven't made a paid product order and are not premium
        $newLeads = User::whereDoesntHave('productOrders', fn ($q) => $q->whereIn('status', ['paid', 'delivered']))
            ->where('is_premium', false)
            ->count();

        // Revenue: Product orders subtotal (INR) + Premium payment orders amount (paise converted to INR)
        $productRevenue = (int) ProductOrder::whereIn('status', ['paid', 'delivered'])->sum('subtotal');
        $premiumRevenue = (int) (PaymentOrder::where('status', 'paid')->sum('amount') / 100);
        $totalRevenue = $productRevenue + $premiumRevenue;

        $stats = [
            ['title' => 'Total Users', 'value' => (string) $totalUsers, 'hint' => 'All registered users'],
            ['title' => 'Successful Orders', 'value' => (string) $successfulOrders, 'hint' => 'Payment completed'],
            ['title' => 'New Leads', 'value' => (string) $newLeads, 'hint' => 'Logged in, no order yet'],
            ['title' => 'Revenue', 'value' => '₹'.number_format($totalRevenue), 'hint' => 'From successful orders & subscriptions'],
        ];

        $recentOrders = ProductOrder::with('user')->latest()->take(5)->get();

        return $this->page('admin.dashboard', 'Dashboard', [
            'stats' => $stats,
            'orders' => $recentOrders,
            'orderStats' => [
                'total' => ProductOrder::count(),
                'successful' => $successfulOrders,
                'pending' => ProductOrder::where('status', 'created')->count(),
                'revenue' => $totalRevenue,
            ],
        ]);
    }

    public function users(): View
    {
        $users = User::withCount(['productOrders', 'savedCards'])->latest()->get();

        $paidCount = 0;
        $unpaidCount = 0;
        $newCount = 0;

        foreach ($users as $user) {
            $status = $user->getPaymentStatus();
            if ($status === 'Paid') {
                $paidCount++;
            } elseif ($status === 'Unpaid') {
                $unpaidCount++;
            } else {
                $newCount++;
            }
        }

        return $this->page('admin.users', 'Users', [
            'users' => $users,
            'counts' => [
                'total' => $users->count(),
                'paid' => $paidCount,
                'unpaid' => $unpaidCount,
                'new' => $newCount,
            ],
        ]);
    }

    public function showUser(User $user): View
    {
        $user->load(['productOrders' => fn ($q) => $q->latest(), 'savedCards' => fn ($q) => $q->latest()]);

        return $this->page('admin.user_detail', $user->name ?: 'User Details', [
            'user' => $user,
            'orders' => $user->productOrders,
            'savedCards' => $user->savedCards,
            'totalSpent' => (int) $user->productOrders()->whereIn('status', ['paid', 'delivered'])->sum('subtotal'),
        ]);
    }

    public function orders(): View
    {
        $orders = ProductOrder::with('user')->latest()->get();
        $planOrders = PaymentOrder::with('user')->latest()->get();

        $successfulProduct = ProductOrder::whereIn('status', ['paid', 'delivered'])->count();
        $successfulPlan = PaymentOrder::where('status', 'paid')->count();
        $successful = $successfulProduct + $successfulPlan;

        $pending = ProductOrder::where('status', 'created')->count() + PaymentOrder::where('status', 'created')->count();
        $productRevenue = (int) ProductOrder::whereIn('status', ['paid', 'delivered'])->sum('subtotal');
        $premiumRevenue = (int) (PaymentOrder::where('status', 'paid')->sum('amount') / 100);

        return $this->page('admin.orders', 'Orders', [
            'orders' => $orders,
            'planOrders' => $planOrders,
            'orderStats' => [
                'total' => $orders->count() + $planOrders->count(),
                'successful' => $successful,
                'pending' => $pending,
                'revenue' => $productRevenue + $premiumRevenue,
            ],
        ]);
    }

    public function showOrder(ProductOrder $order): View
    {
        $order->load(['user.savedCards']);

        return $this->page('admin.order_detail', 'Order '.$order->order_number, [
            'order' => $order,
            'userCards' => $order->user ? $order->user->savedCards : collect(),
        ]);
    }

    public function printOrder(ProductOrder $order): View
    {
        $order->load(['user.savedCards']);

        return view('admin.order_print', [
            'order' => $order,
            'appName' => StaticAdminData::APP_NAME,
            'company' => StaticAdminData::COMPANY,
            'userCards' => $order->user ? $order->user->savedCards : collect(),
        ]);
    }

    public function leads(): View
    {
        $leads = User::whereDoesntHave('productOrders', fn ($q) => $q->whereIn('status', ['paid', 'delivered']))
            ->where('is_premium', false)
            ->latest()
            ->get();

        return $this->page('admin.leads', 'Leads', [
            'leads' => $leads,
            'total' => $leads->count(),
        ]);
    }

    public function settings(): View
    {
        return $this->page('admin.settings', 'Settings', [
            'company' => StaticAdminData::COMPANY,
        ]);
    }

    /** @param  array<string, mixed>  $data */
    private function page(string $view, string $title, array $data = []): View
    {
        return view($view, array_merge($data, [
            'pageTitle' => $title,
            'appName' => StaticAdminData::APP_NAME,
            'sidebar' => StaticAdminData::sidebar(),
            'adminUsername' => session('admin_username', 'admin'),
        ]));
    }
}
